# Changelog

## 0.4.2

### 🚀 Features
- **App Update Check**: Added startup and manual update checks for app platforms, with GitHub Release as the primary destination and Gitee/GitCode as fallback mirrors.
- **Web Refresh Prompt**: Added web update detection with a manual refresh prompt, including a settings entry to check for web updates on demand.
- **Custom Masters Profile Support**: Added full OpenDestiny-side support for custom `命主 / 身主` rule profiles, including profile archive management and editor UI.

### 🛠️ Improvements
- **Unified Version Source**: Added generated `version.json` / `build_info.js` metadata for web deployments so update prompts can compare against a single remote source.
- **Safer Web Update Flow**: Web update checks now run once on startup, retry transient failures a few times, and never auto-refresh in the background.

## 0.4.1

### 🚨 Major Fix
- **BCE Charting Correction**: Fixed incorrect chart generation for BCE dates by aligning the full calendar engine stack with the latest astronomical-year fixes. This resolves previously incorrect Ziwei/Bazi charting results when plotting ancient birth dates.

### 🛠️ Fixes
- **Version Sync**: Bumped the desktop app version to `0.4.1` and synchronized the internal `AppVersion.current` constant.
- **Core Calendar Alignment**: Synchronized the application with the corrected `LunarDate` astronomical-year behavior and historical-year helper APIs from the underlying libraries.

### 📦 Dependency Updates
- `bazi_core`: `^0.6.3`
- `ziwei_core`: `^0.12.3`
- `sxwnl_spa_dart`: `^0.18.1`

## 0.4.0

### 🚀 Features
- **Visual Evolution**: Introduced professional "Stamp-style" palace markers. **ShenGong** (身宫) and **LaiYin** (来因) now appear as refined red vertical stamps with side-by-side layout support.
- **Flow Mode Enhancements**: Added a dedicated blue horizontal stamp for the **Small Limit Life Palace** (小限命宫), automatically triggered in flow mode.
- **BCE Year Support**: Added a global setting to toggle between **Astronomical year numbering** (e.g., -99) and **Historical chronology** (e.g., 100 BC). Fully integrated across Ziwei, Bazi, and Case Library.
- **Core Algorithm**: Implemented the standard **Rat Year DouJun** (子年斗君) derivation logic ("Start from Zi, count CCW by month, CW by hour") using `effectiveMonth`.
- **Streamlined UX**: Creating a new case now automatically triggers navigation to the **Edit Profile** tab for immediate entry.
- **Granular Customization**: Added per-mode display settings for Sanhe, Sihua, and Flying charts, allowing independent control over special palace markers.

### 🛠️ Optimizations
- **Advanced Rendering**: Developed a **dynamic character gap scaling algorithm** based on shrinkage ratios. Shrunken stars now maintain visual integrity with tighter vertical spacing.
- **Bazi Header Refinement**: Synchronized clock time, true solar time, and lunar date display to perfectly align with the core engine's `VirtualTime` architecture.
- **Data Integrity**: Optimized the LaiYin palace algorithm to automatically exclude Zi and Chou positions per specific lineage rules.
- **Documentation**: Comprehensive expansion of README/README_EN focusing on custom profiles and experimental features.

### 📦 Dependency Updates
- Upgraded the core engine matrix to the latest stable releases:
  - `bazi_core`: `^0.6.1`
  - `ziwei_core`: `^0.12.1`
  - `sxwnl_spa_dart`: `^0.17.0`.

---

## 0.3.0
- Implemented comprehensive Ziwei Doushu and Bazi charting modules.
- Added support for Sanhe, Sihua, and Flying star visualization modes.
- Integrated high-precision astronomical calendar calculations.
- Multi-language support (Simplified Chinese, Traditional Chinese, English).
- Robust local case management and JSON export/import.
