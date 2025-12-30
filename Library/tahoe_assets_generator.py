#!/usr/bin/env python3

"""
Tahoe Assets Generator - Generate Assets.car files for macOS Tahoe icon support

Compiles .png files to Assets.car sidecar files to prevent custom icons from
appearing in the "icon jail" on macOS 26+.

Usage: python3 Library/tahoe_assets_generator.py [--icons-dir DIR] [--dry-run] [--force]
"""

import os
import sys
import subprocess
import argparse
from pathlib import Path

def check_dependencies():
    """Check if actool is available."""
    actool_path = "/Applications/Xcode.app/Contents/Developer/usr/bin/actool"

    # Verify actool exists
    if not os.path.exists(actool_path):
        print("ERROR: actool not found. Install Xcode.")
        sys.exit(1)

    # Test actool works
    try:
        subprocess.run([actool_path, "--version"], capture_output=True, check=True)
    except subprocess.CalledProcessError:
        print("ERROR: actool not working. Try: xcodebuild -runFirstLaunch")
        sys.exit(1)

    return actool_path

def process_icon(png_file, tahoe_dir, actool_path, step, total, dry_run=False, force=False):
    """Process a single .png file into Assets.car sidecar file."""
    name = png_file.stem
    output_dir = tahoe_dir / f"{name}_output"
    assets_car = output_dir / "Assets.car"
    final_car = tahoe_dir / f"{name}.car"

    print(f"[{step:>{len(str(total))}}/{total}] Processing {name}")

    # Dry run - just show what would happen
    if dry_run:
        print(f"  -> Would generate: {final_car}")
        print()
        return True

    # Skip if up to date (unless forced)
    if final_car.exists() and not force:
        if png_file.stat().st_mtime <= final_car.stat().st_mtime:
            print(f"  -> ✓ Up to date: {final_car}")
            print()
            return True
    # Remove old check - we'll use the final_car check above

    # Create output directory
    output_dir.mkdir(exist_ok=True)

    # Create .icon file structure
    icon_file = output_dir / f"{name}.icon"
    icon_assets_dir = icon_file / "Assets"
    icon_assets_dir.mkdir(parents=True, exist_ok=True)

    try:
        # Step 1: Create .icon directory structure
        print("  -> Generating .icon file...")
        import shutil
        import json

        # Copy PNG to .icon/Assets/ folder
        shutil.copy2(png_file, icon_assets_dir / f"{name}.png")

        # Create icon.json with exact same structure as bash script
        icon_json = {
            "fill": "automatic",
            "groups": [
                {
                    "layers": [
                        {
                            "hidden": False,
                            "image-name": f"{name}.png",
                            "name": name,
                            "position": {
                                "scale": 1.0,
                                "translation-in-points": [0, 0]
                            }
                        }
                    ],
                    "shadow": {
                        "kind": "neutral",
                        "opacity": 0.3
                    },
                    "translucency": {
                        "enabled": False,
                        "value": 0.0
                    }
                }
            ],
            "supported-platforms": {
                "circles": ["watchOS"],
                "squares": "shared"
            }
        }

        with open(icon_file / "icon.json", "w") as f:
            json.dump(icon_json, f, indent=2)

        # Step 2: Use actool to compile .icon to Assets.car
        print("  -> Compiling with actool...")
        subprocess.run([
            actool_path, str(icon_file),
            "--compile", str(output_dir),
            "--platform", "macosx",
            "--minimum-deployment-target", "11.0",
            "--app-icon", name,
            "--output-partial-info-plist", str(output_dir / "partial-info.plist"),
            "--enable-icon-stack-fallback-generation=disabled"
        ], capture_output=True, check=True, text=True)

        # Clean up temporary .icon directory
        shutil.rmtree(icon_file)

        # Check if compilation succeeded and copy to final location
        if assets_car.exists():
            shutil.copy2(assets_car, final_car)
            shutil.rmtree(output_dir)
            print(f"  -> ✓ Created {final_car}")
            print()
            return True
        else:
            print(f"  -> ERROR: Failed to generate Assets.car")
            print()
            return False

    except subprocess.CalledProcessError as e:
        print(f"  -> ERROR: Processing failed")
        if e.stderr:
            print(f"     {e.stderr.strip()}")
        print()
        return False
    except Exception as e:
        print(f"  -> ERROR: {str(e)}")
        print()
        return False

def main():
    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description="Generate Assets.car sidecar files for macOS Tahoe icon support",
        epilog="""
Examples:
  python3 Library/tahoe_assets_generator.py                    # Generate all Assets.car files
  python3 Library/tahoe_assets_generator.py --dry-run          # Preview what would be done
  python3 Library/tahoe_assets_generator.py --force            # Force regenerate all files
  python3 Library/tahoe_assets_generator.py --icons-dir custom # Use custom/icons directory

Notes:
  - Requires Xcode (for actool)
  - Processes .png files in specified directory
  - Outputs to {icons-dir}/{name}/Assets.car
        """,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("--dry-run", action="store_true", help="Show what would be processed without generating files")
    parser.add_argument("--force", action="store_true", help="Force regeneration of all Assets.car files, even if up to date")
    parser.add_argument("--icons-dir", default="icons/original", help="Directory containing .png files (default: icons/original)")
    args = parser.parse_args()

    print("==> Tahoe Assets Generator for Emacs Icons")
    if args.dry_run:
        print("    [DRY RUN MODE]")
    print()

    # Check icons directory exists
    icons_dir = Path(args.icons_dir)
    if not icons_dir.exists():
        print(f"ERROR: {args.icons_dir}/ directory not found")
        sys.exit(1)

    # Create tahoe directory
    tahoe_dir = Path("icons/tahoe")
    tahoe_dir.mkdir(exist_ok=True)

    # Check dependencies (skip in dry-run to avoid unnecessary checks)
    actool_path = check_dependencies() if not args.dry_run else "/Applications/Xcode.app/Contents/Developer/usr/bin/actool"

    # Find all .png files to process
    png_files = list(icons_dir.glob("*.png"))
    if not png_files:
        print(f"No .png files found in {args.icons_dir}/ directory")
        sys.exit(1)

    # Show what will be processed
    print(f"Found {len(png_files)} .png files:")
    for png_file in sorted(png_files):
        output_path = tahoe_dir / f"{png_file.stem}.car"
        status = "missing"
        if output_path.exists():
            status = "will update" if args.force or output_path.stat().st_mtime <= png_file.stat().st_mtime else "up to date"
        print(f"  - {png_file.stem} ({status})")
    print()

    # Process each .png file
    processed = skipped = 0
    failed = []

    for i, png_file in enumerate(sorted(png_files), 1):
        result = process_icon(png_file, tahoe_dir, actool_path, i, len(png_files), args.dry_run, args.force)
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
            print(f"Failed: {', '.join(failed)}")

    # Exit with error if any failed
    if failed:
        sys.exit(1)

if __name__ == "__main__":
    main()
