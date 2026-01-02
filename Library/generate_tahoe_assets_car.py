#!/usr/bin/env python3

"""
Tahoe Assets Generator - Compile .icon files to Assets.car

This script uses Apple's actool to compile .icon files into Assets.car files
for proper macOS Tahoe icon support without "icon jail" issues.

Assets.car files are the final compiled format required by macOS 26+ (Tahoe)
to properly display custom application icons. Without these files, custom icons
appear with a generic folder overlay indicating improper system integration.

Features:
- Batch processing of all .icon files in the source directory
- Smart timestamp-based up-to-date detection to avoid unnecessary recompilation
- Configuration-based icon skipping via tahoe_config.json
- Dry-run mode for previewing operations without making changes
- Force mode to recompile all Assets.car files regardless of existing files
- Progress tracking with step counters and status reporting
- Comprehensive error handling and reporting

Configuration:
- Config file: Library/tahoe_config.json
- Skip icons by adding them to the "skip_icons" array
- Example: {"skip_icons": ["liquid-glass", "other-icon"]}

Directory Structure:
- Input:  icons/icon-files/  (.icon directory structures)
- Output: icons/macos-26+/   (Assets.car compiled files)
- Config: Library/tahoe_config.json (optional skip configuration)

Usage: python3 Library/generate_tahoe_assets_car.py [--icons-dir DIR] [--dry-run] [--force]
"""

import os
import sys
import json
import shutil
import subprocess
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

def compile_icon_to_car(icon_file, icon_files_dir, macos26_dir, actool, step, total, dry_run=False, force=False):
    """
    Compile a .icon file to Assets.car using actool.

    Processes a single .icon file through the Assets.car compilation pipeline:
    1. Creates temporary output directory
    2. Uses Apple's actool to compile .icon to Assets.car
    3. Moves compiled Assets.car to final location
    4. Cleans up temporary files

    Args:
        icon_file (Path): Path to .icon file
        icon_files_dir (Path): Directory containing .icon files
        macos26_dir (Path): Output directory for Assets.car files
        actool (str): Path to actool executable
        step (int): Current processing step (for progress display)
        total (int): Total number of files to process
        dry_run (bool): If True, only show what would be done
        force (bool): If True, recompile even if file exists

    Returns:
        bool: True if processing succeeded, False if failed
    """
    name = icon_file.stem.replace('.icon', '')
    car_file = macos26_dir / f"{name}.car"

    print(f"[{step:>{len(str(total))}}/{total}] Processing {name}")

    # Dry run - just show what would happen
    if dry_run:
        action = "Would recompile" if car_file.exists() else "Would compile"
        print(f"  -> {action}: {car_file}")
        print()
        return True

    # Skip if up to date (unless forced)
    if car_file.exists() and not force:
        if icon_file.stat().st_mtime <= car_file.stat().st_mtime:
            print(f"  -> Up to date: {car_file}")
            print()
            return True

    try:
        # Create temporary output directory
        output_dir = macos26_dir / f"{name}_output"
        output_dir.mkdir(exist_ok=True)

        # Use actool to compile .icon to Assets.car
        subprocess.run([
            actool, str(icon_file),
            "--compile", str(output_dir),
            "--platform", "macosx",
            "--minimum-deployment-target", "11.0",
            "--app-icon", name,
            "--output-partial-info-plist", str(output_dir / "partial-info.plist"),
            "--enable-icon-stack-fallback-generation=disabled"
        ], check=True, capture_output=True)

        # Move Assets.car to final location
        assets_car = output_dir / "Assets.car"
        if assets_car.exists():
            shutil.copy2(assets_car, car_file)

            # Check for backwards-compatible .icns
            icns_file = output_dir / f"{name}.icns"
            if icns_file.exists():
                print(f"  -> Also generated {name}.icns")

            # Clean up temporary directory
            shutil.rmtree(output_dir)

            action = "Recompiled" if force and car_file.exists() else "Compiled"
            print(f"  -> {action}: {car_file}")
            print()
            return True
        else:
            print(f"  -> ERROR: No Assets.car generated")
            print()
            return False

    except subprocess.CalledProcessError:
        print(f"  -> ERROR: actool compilation failed")
        print()
        return False
    except Exception as e:
        print(f"  -> ERROR: {str(e)}")
        print()
        return False

def main():
    """
    Main function to process all .icon files and generate Assets.car files.

    Orchestrates the complete Assets.car compilation process:
    1. Validates command line arguments and shows help if requested
    2. Checks for required dependencies (Xcode/actool)
    3. Sets up directory structure
    4. Discovers .icon source files
    5. Processes each .icon through the compilation pipeline
    6. Reports final results

    Exit codes:
        0: Success - all icons compiled
        1: Error - missing dependencies, directories, or compilation failure
    """
    parser = argparse.ArgumentParser(
        description="Compile .icon files to Assets.car for macOS Tahoe icon support",
        epilog="""
Examples:
  python3 Library/generate_tahoe_assets_car.py                    # Compile all Assets.car files
  python3 Library/generate_tahoe_assets_car.py --dry-run          # Preview what would be done
  python3 Library/generate_tahoe_assets_car.py --force            # Force recompile all files
  python3 Library/generate_tahoe_assets_car.py --icons-dir custom # Use custom directory

Notes:
  - Requires Xcode (provides actool compiler)
  - Processes .icon files from icon-files directory
  - Outputs to icons/macos-26+/ as Assets.car files
        """,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("--dry-run", action="store_true", help="Show what would be processed without compiling files")
    parser.add_argument("--force", action="store_true", help="Force recompilation of all Assets.car files, even if up to date")
    parser.add_argument("--icons-dir", default="icons/icon-files", help="Directory containing .icon files (default: icons/icon-files)")
    args = parser.parse_args()

    print("==> Tahoe Assets Generator for Emacs Icons")
    if args.dry_run:
        print("    [DRY RUN MODE]")
    if args.force:
        print("    [FORCE MODE]")
    print()

    # Check for actool (skip in dry-run to avoid unnecessary checks)
    actool = "/Applications/Xcode.app/Contents/Developer/usr/bin/actool"
    if not args.dry_run:
        if not os.path.exists(actool):
            print("ERROR: actool not found. Please install Xcode")
            sys.exit(1)

        try:
            subprocess.run([actool, "--version"], check=True, capture_output=True)
        except subprocess.CalledProcessError:
            print("ERROR: actool not working. Try: xcodebuild -runFirstLaunch")
            sys.exit(1)

    # Check icons directory exists
    icons_dir = Path(args.icons_dir)
    if not icons_dir.exists():
        print(f"ERROR: {args.icons_dir}/ directory not found")
        print("Run generate_icon_files.py first")
        sys.exit(1)

    # Create tahoe directory
    macos26_dir = Path("icons/macos-26+")
    if not args.dry_run:
        macos26_dir.mkdir(exist_ok=True)

    # Load configuration for skipped icons
    skip_icons = load_config()
    if skip_icons:
        print(f"Skipping icons from config: {', '.join(sorted(skip_icons))}")
        print()

    # Find all .icon files to process
    icon_files = list(icons_dir.glob("*.icon"))
    if not icon_files:
        print(f"No .icon files found in {args.icons_dir}/ directory")
        print("Run generate_icon_files.py first")
        sys.exit(1)

    # Filter out skipped icons
    filtered_icon_files = []
    skipped_count = 0
    for icon_file in icon_files:
        icon_name = icon_file.stem.replace('.icon', '')
        if icon_name in skip_icons:
            skipped_count += 1
        else:
            filtered_icon_files.append(icon_file)
    
    icon_files = filtered_icon_files

    # Show what will be processed
    total_found = len(icon_files) + skipped_count
    print(f"Found {total_found} .icon files ({len(icon_files)} to process, {skipped_count} skipped):")
    for icon_file in sorted(icon_files):
        output_path = macos26_dir / f"{icon_file.stem.replace('.icon', '')}.car"
        status = "missing"
        if output_path.exists():
            status = "will update" if args.force or icon_file.stat().st_mtime > output_path.stat().st_mtime else "up to date"
        print(f"  - {icon_file.stem.replace('.icon', '')} ({status})")
    print()

    # Process each .icon file
    processed = skipped = 0
    failed = []

    for i, icon_file in enumerate(sorted(icon_files), 1):
        result = compile_icon_to_car(icon_file, icons_dir, macos26_dir, actool, i, len(icon_files), args.dry_run, args.force)
        if result:
            processed += 1
        else:
            failed.append(icon_file.stem.replace('.icon', ''))

    # Show results summary
    print("==> Summary")
    if args.dry_run:
        print(f"Would process {len(icon_files)} .icon files")
    else:
        print(f"Processed: {processed}, Failed: {len(failed)}")
        if failed:
            print(f"Failed: {', '.join(failed)}")

    # Exit with error if any failed
    if failed:
        sys.exit(1)

if __name__ == "__main__":
    main()
