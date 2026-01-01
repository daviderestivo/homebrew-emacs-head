# Icon Generation Scripts

This directory contains three Python scripts for processing Emacs icons for macOS Tahoe compatibility.

## Overview

These scripts work together to convert PNG icons into the proper formats needed for macOS 26+ (Tahoe) to display custom application icons without the "icon jail" overlay.

### Pipeline Flow

```
PNG files → .icon files → Assets.car files
    ↓           ↓             ↓
  Step 1     Step 2       Step 3
```

## Scripts

### 1. `generate_icon_files.py`
Converts PNG files to macOS .icon directory format.

**Input:** `icons/originals/*.png`  
**Output:** `icons/icon-files/*.icon`

```bash
# Generate all .icon files
python3 Library/generate_icon_files.py

# Preview what would be done
python3 Library/generate_icon_files.py --dry-run

# Force regenerate all files
python3 Library/generate_icon_files.py --force

# Use custom source directory
python3 Library/generate_icon_files.py --icons-dir custom/path
```

### 2. `generate_preview_files.py`
Creates 128x128@72dpi preview images for documentation.

**Input:** `icons/originals/*.png`  
**Output:** `icons/previews/*.png`

```bash
# Generate all preview images
python3 Library/generate_preview_files.py

# Preview what would be done
python3 Library/generate_preview_files.py --dry-run

# Force regenerate all files
python3 Library/generate_preview_files.py --force

# Use custom source directory
python3 Library/generate_preview_files.py --icons-dir custom/path
```

**Requirements:** macOS (uses `sips` command)

### 3. `generate_tahoe_assets_car.py`
Compiles .icon files to Assets.car files using Apple's actool.

**Input:** `icons/icon-files/*.icon`  
**Output:** `icons/macos-26+/*.car`

```bash
# Compile all Assets.car files
python3 Library/generate_tahoe_assets_car.py

# Preview what would be done
python3 Library/generate_tahoe_assets_car.py --dry-run

# Force recompile all files
python3 Library/generate_tahoe_assets_car.py --force

# Use custom source directory
python3 Library/generate_tahoe_assets_car.py --icons-dir custom/path
```

**Requirements:** Xcode (provides `actool`)

## Common Options

All scripts support these options:

- `--help` / `-h` - Show detailed help with examples
- `--dry-run` - Preview operations without making changes
- `--force` - Force regeneration even if files are up to date
- `--icons-dir DIR` - Specify custom input directory

## Quick Start

### Complete Pipeline
Run all three scripts in sequence:

```bash
# Step 1: Create .icon files from PNG sources
python3 Library/generate_icon_files.py

# Step 2: Create preview images (optional)
python3 Library/generate_preview_files.py

# Step 3: Compile Assets.car files
python3 Library/generate_tahoe_assets_car.py
```

### Preview Mode
Test the complete pipeline without making changes:

```bash
python3 Library/generate_icon_files.py --dry-run
python3 Library/generate_preview_files.py --dry-run
python3 Library/generate_tahoe_assets_car.py --dry-run
```

## Directory Structure

```
icons/
├── originals/       # Source PNG files
├── icon-files/     # Generated .icon directories
├── previews/        # 128x128 preview images
├── macos-legacy/   # Legacy .icns files for macOS < 26
└── macos-26+/      # Modern Assets.car files for macOS 26+
```

## Requirements

- **Python 3.6+**
- **macOS** (for `sips` command in preview generation)
- **Xcode** (for `actool` in Assets.car compilation)

## Troubleshooting

### actool not found
```bash
# Install Xcode from App Store, then run:
xcodebuild -runFirstLaunch
```

### No PNG files found
Ensure PNG files are in `icons/originals/` directory or specify custom path with `--icons-dir`.

### Permission errors
Ensure write permissions for output directories (`icons/icon-files/`, `icons/previews/`, `icons/tahoe/`).

## Exit Codes

- `0` - Success
- `1` - Error (missing dependencies, files, or processing failure)

## Examples

### Process specific icons only
```bash
# Create custom directory with subset of icons
mkdir icons/custom
cp icons/originals/my-icon.png icons/custom/

# Process only those icons
python3 Library/generate_icon_files.py --icons-dir icons/custom
python3 Library/generate_tahoe_assets_car.py --icons-dir icons/custom
```

### Force regeneration
```bash
# Regenerate everything from scratch
python3 Library/generate_icon_files.py --force
python3 Library/generate_tahoe_assets_car.py --force
```

### Check what needs updating
```bash
# See which files would be processed
python3 Library/generate_icon_files.py --dry-run
python3 Library/generate_tahoe_assets_car.py --dry-run
```
