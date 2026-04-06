# Changelog

## 0.5.2

### 🛠️ Fixes
- **Flow-Star Visibility Controls**: Added per-flow-star visibility toggles in Ziwei settings, split them cleanly from the existing “override original slots” switches, and made hidden flow stars stop participating in overlay and bottom-slot replacement rendering.
- **Flow Twelve-God Palette Fix**: Fixed the bottom `博士 / 岁建 / 将前` twelve-god rows so fallback original-star colors now respect the custom Ziwei palette instead of always using the generic minor-star color.
- **Historical Calendar Setting Wording**: Renamed the historical-calendar toggle to reflect its real behavior: turning it off now means not using the new-moon correction table.
- **Global Theme Color Presets**: Added app-wide theme color presets, removed the hardcoded purple seed theme, and wired key list/summary/selection UI states to follow the selected global accent color.
- **Third-Party License Notice**: Added AreaCity-JsSpider-StatsGov city coordinate data attribution to the in-app About/license list.

## 0.5.1

### 🛠️ Fixes
- **README Notice Update**: Added a clear notice to both Chinese and English READMEs that Ziwei/Dou Shu English localization is still in progress.
- **Ziwei I18n Fill-ins**: Added missing localization entries for the new Ziwei center legend and static star visibility preset texts.

### 📦 Dependency Updates
- `bazi_core`: `^0.6.5`
- `ziwei_core`: `^0.12.9`
- `sxwnl_spa_dart`: `^0.18.4`

## 0.5.0

### 🛠️ Fixes
- **Center Legend & Readability**: Added a lightweight `禄 权 科 忌` color legend in the Ziwei center panel and darkened the fortune-year labels under the center Bazi block for better readability.
- **Static Star Visibility Presets**: Added per-mode static star visibility presets for `三合 / 四化 / 飞星`, with defaults set to `full / compact / compact`.
- **Custom Star Visibility JSON**: Added raw JSON editing for static star visibility so each chart mode can maintain its own `blockedStars` list without affecting flow-star rendering.

### 📦 Dependency Updates
- `bazi_core`: `^0.6.5`
- `ziwei_core`: `^0.12.9`
- `sxwnl_spa_dart`: `^0.18.4`

## 0.4.8

### 🛠️ Fixes
- **Split Rat Hour Consistency**: Synced the updated `ziwei_core 0.12.9` rat-hour logic so Ziwei charting now handles early/late Zi hour transitions consistently, including correct stem resolution, timeline labels, and rechart behavior when split rat hour is enabled.
- **Split Rat Hour Blank Screen Fix**: Fixed a Ziwei chart rendering failure where enabling early/late Zi hour handling could leave the Ziwei chart page blank under certain recalculation paths.
- **Dynamic Brightness Palette**: Reworked Ziwei custom color settings so brightness colors now follow the active brightness ruleset dynamically instead of being hardcoded to seven classic levels. Custom brightness profiles with arbitrary level counts now render and persist correctly.

### 📦 Dependency Updates
- `bazi_core`: `^0.6.5`
- `ziwei_core`: `^0.12.9`
- `sxwnl_spa_dart`: `^0.18.4`

## 0.4.7

### 🛠️ Fixes
- **Ziwei Rechart Stability**: Synced `ziwei_core 0.12.8` so repeated chart recalculation after switching hour/day no longer reuses polluted static-star instances, fixing incorrect self-transform arrow states after stepping forward and back.

### 📦 Dependency Updates
- `bazi_core`: `^0.6.5`
- `ziwei_core`: `^0.12.8`
- `sxwnl_spa_dart`: `^0.18.4`

## 0.4.6

### 🛠️ Fixes
- **Flow Month Preview Alignment**: Aligned Ziwei flow-month preview actions with the timeline sequence so cross-year months and leap-month ordering resolve against the same month node the engine uses internally.

### 📦 Dependency Updates
- `bazi_core`: `^0.6.5`
- `ziwei_core`: `^0.12.7`
- `sxwnl_spa_dart`: `^0.18.4`

## 0.4.5

### 🛠️ Fixes
- **BCE Flow-Day Restoration**: Synced the latest BCE lunar-year matching fixes from the calendar engine stack so ancient charts can expand all flow months into flow days again.

### 📦 Dependency Updates
- `bazi_core`: `^0.6.5`
- `ziwei_core`: `^0.12.7`
- `sxwnl_spa_dart`: `^0.18.4`

## 0.4.4

### 🎨 UI
- **Ziwei Readability Tuning**: Increased contrast for bad stars, lucky stars, minor stars, center-panel birth info, and time-flow sublabels to improve readability on mobile screens.
- **Bazi Readability Tuning**: Strengthened the lunar time, hidden stem labels, and `起运 / 司令` info so key auxiliary text is easier to read.

## 0.4.3

### 🛠️ Fixes
- **Update Check Reliability**: Fixed update checks on Android release builds and aligned platform permissions for desktop/app update requests.
- **Web Update Check Flow**: Hardened the web update-check path and manual refresh entry so remote version metadata can be checked more reliably.

### 🎨 UI
- **Windows Font Preference**: Prefer `Microsoft YaHei` as the global app font on supported systems, while letting unsupported platforms fall back to their default system fonts.

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
