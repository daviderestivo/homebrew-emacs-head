# Icon Generation Scripts

This directory contains Python scripts for processing Emacs icons into different formats for macOS compatibility and documentation.

## Overview

There are two main workflows:

1. **Icon Asset Generation** - Creates macOS-compatible icon formats for Homebrew formula
2. **Preview Generation** - Creates standardized preview images for documentation

## Workflow 1: Icon Asset Generation

This workflow converts PNG source files into macOS-compatible icon formats to avoid the "icon jail" overlay on macOS 26+ (Tahoe).

### Pipeline Flow
```
PNG sources → .icon directories → Assets.car files
     ↓              ↓                  ↓
   Step 1         Step 2            Step 3
```

### Step 1: Generate .icon Files

**Script:** `generate_icon_files.py`  
**Input:** `icons/originals/*.png`  
**Output:** `icons/icon-files/*.icon`

Converts PNG files to macOS .icon directory format with proper metadata.

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

### Step 2: Generate Assets.car Files

**Script:** `generate_tahoe_assets_car.py`  
**Input:** `icons/icon-files/*.icon`  
**Output:** `icons/macos-26+/*.car`

Compiles .icon directories into Assets.car files using Apple's actool for modern macOS versions.

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

### Complete Icon Asset Workflow

```bash
# Run complete pipeline
python3 Library/generate_icon_files.py
python3 Library/generate_tahoe_assets_car.py

# Or preview the complete pipeline
python3 Library/generate_icon_files.py --dry-run
python3 Library/generate_tahoe_assets_car.py --dry-run
```

## Workflow 2: Preview Generation

This workflow creates standardized preview images for documentation and README files.

### Single Step Process

**Script:** `generate_preview_files.py`  
**Input:** `icons/originals/*.png`  
**Output:** `icons/previews/*.png`

Creates 128x128@72dpi standardized preview images directly from PNG sources.

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

## Directory Structure

```
icons/
├── originals/       # Source PNG files (input for both workflows)
├── icon-files/      # Generated .icon directories (Workflow 1, Step 1)
├── macos-26+/       # Modern Assets.car files (Workflow 1, Step 2)
├── previews/        # 128x128 preview images (Workflow 2)
└── macos-legacy/    # Legacy .icns files (for reference)
```

## Common Options

All scripts support these options:

- `--help` / `-h` - Show detailed help with examples
- `--dry-run` - Preview operations without making changes
- `--force` - Force regeneration even if files are up to date
- `--icons-dir DIR` - Specify custom input directory

## Requirements

- **Python 3.6+**
- **macOS** (for preview generation using `sips`)
- **Xcode** (for Assets.car compilation using `actool`)

## Use Cases

### Adding New Icons
When adding new PNG files to `icons/originals/`:

```bash
# For Homebrew formula (icon assets)
python3 Library/generate_icon_files.py
python3 Library/generate_tahoe_assets_car.py

# For documentation (previews)
python3 Library/generate_preview_files.py
```

### Documentation Only
When you only need preview images for README updates:

```bash
python3 Library/generate_preview_files.py
```

### Formula Development
When working on Homebrew formula icon integration:

```bash
python3 Library/generate_icon_files.py
python3 Library/generate_tahoe_assets_car.py
```

## Troubleshooting

### actool not found
```bash
# Install Xcode from App Store, then run:
xcodebuild -runFirstLaunch
```

### No PNG files found
Ensure PNG files are in `icons/originals/` directory or specify custom path with `--icons-dir`.

### Permission errors
Ensure write permissions for output directories (`icons/icon-files/`, `icons/previews/`, `icons/macos-26+/`).

## Exit Codes

- `0` - Success
- `1` - Error (missing dependencies, files, or processing failure)

## Examples

### Process specific icons only
```bash
# Create custom directory with subset of icons
mkdir icons/custom
cp icons/originals/my-icon.png icons/custom/

# Run workflows on subset
python3 Library/generate_icon_files.py --icons-dir icons/custom
python3 Library/generate_tahoe_assets_car.py --icons-dir icons/custom
python3 Library/generate_preview_files.py --icons-dir icons/custom
```

### Force regeneration
```bash
# Regenerate everything from scratch
python3 Library/generate_icon_files.py --force
python3 Library/generate_tahoe_assets_car.py --force
python3 Library/generate_preview_files.py --force
```

### Check what needs updating
```bash
# See which files would be processed
python3 Library/generate_icon_files.py --dry-run
python3 Library/generate_tahoe_assets_car.py --dry-run
python3 Library/generate_preview_files.py --dry-run
```
