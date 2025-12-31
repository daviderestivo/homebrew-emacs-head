#!/usr/bin/env python3

"""
Preview Generator - Generate 128x128@72dpi preview images for icon documentation

This script processes PNG files from the original icons directory and creates
standardized preview images for use in README documentation. All preview images
are resized to 128x128 pixels at 72 DPI for consistent display across different
platforms and documentation viewers.

The script uses macOS's built-in 'sips' command for high-quality image processing
and maintains aspect ratios while fitting images within the 128x128 pixel bounds.

Features:
- Batch processing of all PNG files in the source directory
- Smart timestamp-based up-to-date detection to avoid unnecessary regeneration
- Dry-run mode for previewing operations without making changes
- Force mode to regenerate all previews regardless of timestamps
- Progress tracking with step counters and status reporting
- Comprehensive error handling and reporting

Directory Structure:
- Input:  icons/original/    (source PNG files from .icns conversion)
- Output: icons/preview/     (128x128@72dpi standardized previews)

Usage: python3 Library/generate_preview_files.py [--icons-dir DIR] [--dry-run] [--force]
"""

import os
import sys
import subprocess
import argparse
from pathlib import Path

def check_dependencies():
    """
    Check if sips command is available on the system.

    The sips (Scriptable Image Processing System) command is built into macOS
    and provides high-quality image processing capabilities. This function
    verifies that sips is available and working properly.

    Returns:
        str: The command name "sips" if available

    Exits:
        Terminates the script if sips is not found or not working
    """
    try:
        subprocess.run(["sips", "--version"], capture_output=True, check=True)
        return "sips"
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("ERROR: sips not found. This script requires macOS.")
        sys.exit(1)

def process_icon(png_file, preview_dir, step, total, dry_run=False, force=False):
    """
    Process a single PNG file into a standardized 128x128@72dpi preview image.

    This function takes a source PNG file and creates a preview version with
    standardized dimensions and DPI settings. The preview maintains the original
    aspect ratio while fitting within 128x128 pixel bounds.

    Args:
        png_file (Path): Path to the source PNG file
        preview_dir (Path): Directory where preview images will be saved
        step (int): Current processing step number (for progress display)
        total (int): Total number of files to process
        dry_run (bool): If True, only show what would be done without processing
        force (bool): If True, regenerate even if preview is up to date

    Returns:
        bool: True if processing succeeded, False if it failed

    Processing Steps:
        1. Check if preview file exists and is up to date (unless force=True)
        2. Use sips to resize image to 128x128 pixels
        3. Set DPI to 72 for consistent display across platforms
        4. Verify the output file was created successfully
    """
    name = png_file.stem
    preview_file = preview_dir / f"{name}.png"

    print(f"[{step:>{len(str(total))}}/{total}] Processing {name}")

    # Dry run - just show what would happen
    if dry_run:
        print(f"  -> Would generate: {preview_file}")
        print()
        return True

    # Skip if up to date (unless forced)
    if preview_file.exists() and not force:
        if png_file.stat().st_mtime <= preview_file.stat().st_mtime:
            print(f"  -> Up to date: {preview_file}")
            print()
            return True

    try:
        # Generate 128x128@72dpi preview using sips
        print("  -> Generating preview...")
        subprocess.run([
            "sips",
            "-z", "128", "128",  # Resize to 128x128
            "-s", "dpiHeight", "72",  # Set DPI to 72
            "-s", "dpiWidth", "72",
            str(png_file),
            "--out", str(preview_file)
        ], capture_output=True, check=True, text=True)

        if preview_file.exists():
            print(f"  -> Created {preview_file}")
            print()
            return True
        else:
            print(f"  -> ERROR: Failed to generate preview")
            print()
            return False

    except subprocess.CalledProcessError as e:
        print(f"  -> ERROR: Processing failed")
        if e.stderr:
            print(f"     {e.stderr.strip()}")
        print()
        return False
    except Exception as e:
        print(f"  -> ERROR: {e}")
        print()
        return False

def main():
    """
    Main function to process all PNG files in the source directory.

    This function orchestrates the entire preview generation process:
    1. Parses command line arguments for configuration options
    2. Validates that source and destination directories exist
    3. Discovers all PNG files in the source directory
    4. Checks dependencies (sips command availability)
    5. Processes each PNG file to create standardized previews
    6. Provides comprehensive progress reporting and error handling

    Command Line Arguments:
        --dry-run: Preview operations without making changes
        --force: Regenerate all previews regardless of timestamps
        --icons-dir: Specify custom source directory (default: icons/original)

    Exit Codes:
        0: Success - all files processed without errors
        1: Error - missing dependencies, directories, or processing failures
    """
    parser = argparse.ArgumentParser(
        description="Generate 128x128@72dpi preview images for icon documentation",
        epilog="""
Examples:
  python3 Library/generate_preview_files.py                    # Generate all preview images
  python3 Library/generate_preview_files.py --dry-run          # Preview what would be done
  python3 Library/generate_preview_files.py --force            # Force regenerate all files
  python3 Library/generate_preview_files.py --icons-dir custom # Use custom directory

Notes:
  - Requires macOS (uses sips command)
  - Processes PNG files from original directory
  - Outputs to icons/preview/ at 128x128@72dpi
        """,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("--dry-run", action="store_true", help="Show what would be processed without generating files")
    parser.add_argument("--force", action="store_true", help="Force regeneration of all preview files, even if up to date")
    parser.add_argument("--icons-dir", default="icons/original", help="Directory containing source .png files (default: icons/original)")
    args = parser.parse_args()

    print("==> Preview Generator for Emacs Icons")
    if args.dry_run:
        print("    [DRY RUN MODE]")
    print()

    # Check icons directory exists
    icons_dir = Path(args.icons_dir)
    if not icons_dir.exists():
        print(f"ERROR: {args.icons_dir}/ directory not found")
        sys.exit(1)

    # Create preview directory
    preview_dir = Path("icons/preview")
    preview_dir.mkdir(exist_ok=True)

    # Check dependencies (skip in dry-run to avoid unnecessary checks)
    if not args.dry_run:
        check_dependencies()

    # Find all .png files to process
    png_files = list(icons_dir.glob("*.png"))
    if not png_files:
        print(f"No .png files found in {args.icons_dir}/ directory")
        sys.exit(1)

    # Show what will be processed
    print(f"Found {len(png_files)} .png files:")
    for png_file in sorted(png_files):
        output_path = preview_dir / f"{png_file.stem}.png"
        status = "missing"
        if output_path.exists():
            status = "will update" if args.force or output_path.stat().st_mtime <= png_file.stat().st_mtime else "up to date"
        print(f"  - {png_file.stem} ({status})")
    print()

    # Process each .png file
    processed = skipped = 0
    failed = []

    for i, png_file in enumerate(sorted(png_files), 1):
        result = process_icon(png_file, preview_dir, i, len(png_files), args.dry_run, args.force)
        if result == "skipped":
            skipped += 1
        elif result:
            processed += 1
        else:
            failed.append(png_file.stem)

    # Show results summary
    print("==> Summary")
    if args.dry_run:
        print(f"Would process {len(png_files)} .png files")
    else:
        print(f"Processed: {processed}, Skipped: {skipped}, Failed: {len(failed)}")
        if failed:
            print(f"Failed icons: {', '.join(failed)}")

if __name__ == "__main__":
    main()
