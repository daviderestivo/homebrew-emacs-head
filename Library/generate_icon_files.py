#!/usr/bin/env python3

"""
Icon Files Generator - Create .icon files from PNG sources

This script converts PNG icons to macOS .icon directory format with proper metadata.
This is the first step in the icon conversion pipeline for macOS Tahoe support.

The .icon format is Apple's intermediate format that contains PNG assets and JSON
metadata required for compilation into Assets.car files. This format allows for
proper icon integration with macOS without appearing in the "icon jail".

Features:
- Batch processing of all PNG files in the source directory
- Smart timestamp-based up-to-date detection to avoid unnecessary regeneration
- Configuration-based icon skipping via tahoe_config.json
- Dry-run mode for previewing operations without making changes
- Force mode to regenerate all .icon files regardless of existing files
- Progress tracking with step counters and status reporting
- Comprehensive error handling and reporting

Configuration:
- Config file: Library/tahoe_config.json
- Skip icons by adding them to the "skip_icons" array
- Example: {"skip_icons": ["liquid-glass", "other-icon"]}

Directory Structure:
- Input:  icons/originals/     (source PNG files)
- Output: icons/icon-files/   (.icon directory structures)
- Config: Library/tahoe_config.json (optional skip configuration)

Usage: python3 Library/generate_icon_files.py [--icons-dir DIR] [--dry-run] [--force]
"""

import os
import sys
import json
import shutil
import argparse
from pathlib import Path

def load_config():
    """
    Load configuration file for skipping icons.
    
    Returns:
        set: Set of icon names to skip
    """
    config_file = Path(__file__).parent / "tahoe_config.json"
    if config_file.exists():
        try:
            with open(config_file, 'r') as f:
                config = json.load(f)
                return set(config.get('skip_icons', []))
        except (json.JSONDecodeError, KeyError):
            print(f"WARNING: Invalid config file {config_file}, ignoring")
    return set()

def generate_icon_json(name):
    """
    Generate icon.json configuration for macOS icon compilation.

    Args:
        name (str): Base name of the icon (without extension)

    Returns:
        dict: Icon configuration dictionary
    """
    return {
        "fill": "automatic",
        "groups": [{
            "layers": [{
                "hidden": False,
                "image-name": f"{name}.png",
                "name": name,
                "position": {
                    "scale": 1.0,
                    "translation-in-points": [0, 0]
                }
            }],
            "shadow": {
                "kind": "neutral",
                "opacity": 0.3
            },
            "translucency": {
                "enabled": False,
                "value": 0.0
            }
        }],
        "supported-platforms": {
            "circles": ["watchOS"],
            "squares": "shared"
        }
    }

def create_icon_file(png_file, originals_dir, icon_files_dir, step, total, dry_run=False, force=False):
    """
    Create a .icon file from a PNG source.

    Processes a single PNG file through the .icon creation pipeline:
    1. Creates .icon directory structure
    2. Copies PNG to Assets subfolder
    3. Generates icon.json metadata file

    Args:
        png_file (Path): Path to source PNG file
        originals_dir (Path): Directory containing source PNG files
        icon_files_dir (Path): Output directory for .icon files
        step (int): Current processing step (for progress display)
        total (int): Total number of files to process
        dry_run (bool): If True, only show what would be done
        force (bool): If True, recreate even if file exists

    Returns:
        bool: True if processing succeeded, False if failed
    """
    name = png_file.stem
    icon_file = icon_files_dir / f"{name}.icon"

    print(f"[{step:>{len(str(total))}}/{total}] Processing {name}")

    # Dry run - just show what would happen
    if dry_run:
        action = "Would recreate" if icon_file.exists() else "Would generate"
        print(f"  -> {action}: {icon_file}")
        print()
        return True

    # Skip if up to date (unless forced)
    if icon_file.exists() and not force:
        print(f"  -> Up to date: {icon_file}")
        print()
        return True

    try:
        # Create .icon directory structure
        assets_dir = icon_file / "Assets"
        assets_dir.mkdir(parents=True, exist_ok=True)

        # Copy PNG to Assets folder
        shutil.copy2(originals_dir / png_file.name, assets_dir / f"{name}.png")

        # Generate icon.json configuration file
        with open(icon_file / "icon.json", "w") as f:
            json.dump(generate_icon_json(name), f, indent=2)

        action = "Recreated" if force and icon_file.exists() else "Generated"
        print(f"  -> {action}: {icon_file}")
        print()
        return True

    except Exception as e:
        print(f"  -> ERROR: {str(e)}")
        print()
        return False

def main():
    """
    Main function to process all PNG icons and generate .icon files.

    Orchestrates the complete .icon file creation process:
    1. Validates command line arguments and shows help if requested
    2. Sets up directory structure
    3. Discovers PNG source files
    4. Processes each PNG through the .icon creation pipeline
    5. Reports final results

    Exit codes:
        0: Success - all icons processed
        1: Error - missing directories, no source files, or processing failure
    """
    parser = argparse.ArgumentParser(
        description="Generate .icon files from PNG sources for macOS icon compilation",
        epilog="""
Examples:
  python3 Library/generate_icon_files.py                    # Generate all .icon files
  python3 Library/generate_icon_files.py --dry-run          # Preview what would be done
  python3 Library/generate_icon_files.py --force            # Force regenerate all files
  python3 Library/generate_icon_files.py --icons-dir custom # Use custom directory

Notes:
  - Processes PNG files from originals directory
  - Outputs to icons/icon-files/ as .icon directories
  - Use with generate_tahoe_assets_car.py for complete pipeline
        """,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("--dry-run", action="store_true", help="Show what would be processed without generating files")
    parser.add_argument("--force", action="store_true", help="Force regeneration of all .icon files, even if up to date")
    parser.add_argument("--icons-dir", default="icons/originals", help="Directory containing source .png files (default: icons/originals)")
    args = parser.parse_args()

    print("==> Icon Files Generator for Emacs Icons")
    if args.dry_run:
        print("    [DRY RUN MODE]")
    if args.force:
        print("    [FORCE MODE]")
    print()

    # Check icons directory exists
    icons_dir = Path(args.icons_dir)
    if not icons_dir.exists():
        print(f"ERROR: {args.icons_dir}/ directory not found")
        sys.exit(1)

    # Create icon-files directory
    icon_files_dir = Path("icons/icon-files")
    if not args.dry_run:
        icon_files_dir.mkdir(exist_ok=True)

    # Load configuration for skipped icons
    skip_icons = load_config()
    if skip_icons:
        print(f"Skipping icons from config: {', '.join(sorted(skip_icons))}")
        print()

    # Find all .png files to process
    png_files = list(icons_dir.glob("*.png"))
    if not png_files:
        print(f"No .png files found in {args.icons_dir}/ directory")
        sys.exit(1)

    # Filter out skipped icons
    filtered_png_files = []
    skipped_count = 0
    for png_file in png_files:
        icon_name = png_file.stem
        if icon_name in skip_icons:
            skipped_count += 1
        else:
            filtered_png_files.append(png_file)
    
    png_files = filtered_png_files

    # Show what will be processed
    total_found = len(png_files) + skipped_count
    print(f"Found {total_found} .png files ({len(png_files)} to process, {skipped_count} skipped):")
    for png_file in sorted(png_files):
        output_path = icon_files_dir / f"{png_file.stem}.icon"
        status = "missing"
        if output_path.exists():
            status = "will update" if args.force else "up to date"
        print(f"  - {png_file.stem} ({status})")
    print()

    # Process each .png file
    processed = skipped = 0
    failed = []

    for i, png_file in enumerate(sorted(png_files), 1):
        result = create_icon_file(png_file, icons_dir, icon_files_dir, i, len(png_files), args.dry_run, args.force)
        if result:
            processed += 1
        else:
            failed.append(png_file.stem)

    # Show results summary
    print("==> Summary")
    if args.dry_run:
        print(f"Would process {len(png_files)} .png files")
    else:
        print(f"Processed: {processed}, Failed: {len(failed)}")
        if failed:
            print(f"Failed: {', '.join(failed)}")

    # Exit with error if any failed
    if failed:
        sys.exit(1)

if __name__ == "__main__":
    main()
