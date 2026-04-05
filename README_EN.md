<p align="center">
  <img src="assets/images/splash_logo.png" alt="OpenDestiny Logo" width="400">
</p>

<h1 align="center">🔮 OpenDestiny </h1>

<p align="center">
  <em>A modern, professional-grade traditional Chinese astrology application built with Flutter.</em>
</p>

<p align="center">
  <img alt="Flutter Version" src="https://img.shields.io/badge/Flutter-3.16+-blue.svg?style=flat-square&logo=flutter">
  <img alt="Dart SDK" src="https://img.shields.io/badge/Dart-3.0+-blue.svg?style=flat-square&logo=dart">
  <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green.svg?style=flat-square">
</p>

<p align="center">
  <strong>Try it now:</strong> Open the Web Demo and start charting immediately, no installation required.
</p>

<p align="center">
  <a href="https://opendestiny.redsc1.com/app/">
    <img alt="Web Demo" src="https://img.shields.io/badge/Web%20Demo-Launch%20Now-0A7CFF?style=for-the-badge">
  </a>
</p>

<p align="center">
  <a href="https://opendestiny.redsc1.com/app/"><strong>Launch Web Demo</strong></a>
</p>

---

## 🌟 Introduction

**OpenDestiny** is a modern, professional-grade traditional Chinese astrology (Ziwei Doushu & Bazi) cross-platform application built with Flutter.

More than just a tool with a beautiful interface, it serves as a **UI implementation benchmark** for its underlying astrological engine matrix. By bridging rigorous modern software engineering with ancient metaphysical logic, OpenDestiny aims to provide a sophisticated platform for the **digital archiving** and **empirical research** of traditional culture.

### 💎 Technical Highlights

*   **🛠️ Platform-Agnostic Logic**: Built on a modular matrix of pure Dart libraries. Achieves 100% cross-platform logic parity and high-performance offline computation without native binary dependencies.
*   **⏳ Extended Chronological Range**: Theoretically supports full chart generation and progression from 1000 BCE to 9999 CE*, covering the vast majority of historical and future calendar epochs.
*   **🎯 True Solar Time Correction**: Employs high-precision astronomical algorithms for location-based True Solar Time calibration and precise day-transition (Early/Late Zi) logic.
*   **🧪 Neutral Logical Scrutiny**: Deconstructs traditional rules into programmable logic. Provides a neutral platform for researchers to independently **verify or falsify** theories against historical data.

**Project Mission**: This project serves primarily as an electronic archive for traditional astrology and predictive sciences. We do not assume the validity of any metaphysical theories. Instead, we provide a neutral, precise computational platform through modern software engineering, supporting rigorous reviews and letting users scrutinize the logic against objective data.

---
> \*Note: Due to the long-term drift of Earth's rotation (ΔT), astronomical time predictions after 2025 CE will gradually decrease in precision over time.

## ✨ Key Features

*   **📊 Comprehensive Charting**
    *   **Ziwei Doushu**: Supports Heaven/Earth/Human plates with Sanhe, Feixing, and Sihua mode switching.
    *   **Bazi**: Visual representation of interactions (clashes, harms, etc.) and automatic Shensha calculation.
    *   **Dynamic Progression**: Stateful tracking of time-scales from Decades (Daxian) down to specific Hours (Liushi).
*   **📡 High-Precision Computation**
    *   **Astronomical Algorithms**: True Solar Time correction and precise handling of Early/Late Zi hour transitions.
    *   **Broad Range**: Theoretically supports 10,000-year historical and future calendar ranges.
*   **🛠️ Architecture & Tech Stack**
    *   **State Management**: Fully powered by `Riverpod` + `Freezed` for a predictable, decoupled logic flow.
    *   **Type Safety**: Robust data serialization handled by `json_serializable`.
*   **🌐 Cross-Platform Deployment**
    *   **Native-Free**: 100% pure Dart core logic—no C++/JNI dependencies, ensuring high portability.
    *   **Unified Codebase**: Native binaries for Android, iOS, Windows, macOS, Linux, and high-performance Web builds.

---

## 🏛️ Architecture & Component Matrix

### 🏗️ Logical Architecture
OpenDestiny follows the **Detached Logic & UI** principle. All astrological computations are handled by independent Dart core libraries, while Flutter acts solely as the rendering layer:

```text
[ User Input ] ──► [ BirthData Model ] ──► [ Riverpod Providers ]
                                               │
                                               ▼
[ Flutter UI ] ◄── [ Immutable State ] ◄── [ Core Engines ]
(Material 3)        (Freezed/Models)       (Bazi/Ziwei/SPA)
```

### 📦 Core Components
The application is built upon a suite of modular, open-source libraries published on Pub.dev:

1.  📦 **[`sxwnl_spa_dart`](https://pub.dev/packages/sxwnl_spa_dart)** (v0.18.4): High-precision astronomical calendar and solar term computations.
2.  📦 **[`bazi_core`](https://pub.dev/packages/bazi_core)** (v0.6.5): The logic engine for Bazi pillars, luck cycles, and interactions.
3.  📦 **[`ziwei_core`](https://pub.dev/packages/ziwei_core)** (v0.12.8): The rule-engine for plotting Ziwei Doushu star positions and transformations.

### 📂 Directory Structure
The project adopts a **Feature-first** organization, facilitating horizontal scaling for new astrological modules:

```text
lib/
├── core/           # Routing, themes, persistence, and shared utilities
├── data/           # Static assets and database mapping (e.g., city database)
├── features/       # 🚀 Core business modules (bazi, ziwei, profile, settings)
├── models/         # Cross-module domain entities (e.g., BirthData)
└── main.dart       # Application entry point with ProviderScope root
```

---

## 🚀 Key Features

### 1. Open Custom Profiles
Unlike typical charting software with hard-coded logic, OpenDestiny provides a highly flexible customization pipeline for various lineages:
*   **SiHua Rule Customization**: Manually edit the "Lu, Quan, Ke, Ji" mappings for the ten stems via visual tables or standard JSON protocols.
*   **Star Brightness System**: Customize brightness levels (Miao, Wang, De, Li, Ping, Bu, Xian) for all 12 branches, with fully configurable labels and visual weights.
*   **Seamless Migration**: Export custom profiles as JSON strings for instant sharing and import across devices.

### 2. Digital Case Management
A standardized archival solution for destiny data, solving cross-platform fragmentation:
*   **Full JSON Export/Import**: Export local case libraries (including name, birth data, coordinates) as structured JSON for research or manual sync.
*   **Multi-channel Sharing**: Leverage Flutter's capabilities to share cases or profiles via files, QR codes, or the system clipboard.
*   **High-Precision Geodata**: Built-in calibrated city database for automatic timezone matching and True Solar Time correction.

### 3. Experimental: Bazi ShenSha Module
Exploring the path of transforming traditional symbolic stars into programmable logic:
*   **ShenSha Matrix**: Initial integration of core algorithms including Noble, Horse, KongWang, and KuiGang.
*   **Engineering Note**: This module is marked as "experimental" to test algorithmic robustness. Due to the vast discrepancies in rules across lineages, results are for reference only and have not undergone large-scale manual verification.

### 4. Advanced Historical Chronology
*   **Dual-mode Year Display**: Seamlessly toggle between **Astronomical year numbering** (including Year 0 and negatives) and **Historical chronology** (BC/AD format) for precise ancient chart analysis.
*   **Calendar Protection**: Built-in alerts for historical calendar "red zones" with automatic handling of astronomical offsets for specific dynasties.

---

## 🛠️ Quick Start (Development)

### 1. Open Custom Profiles
Unlike typical charting software with hard-coded logic, OpenDestiny provides a highly flexible customization pipeline for various lineages:
*   **SiHua Rule Customization**: Manually edit the "Lu, Quan, Ke, Ji" mappings for the ten stems via visual tables or standard JSON protocols.
*   **Star Brightness System**: Customize brightness levels (Miao, Wang, De, Li, Ping, Bu, Xian) for all 12 branches, with fully configurable labels and visual weights.
*   **Seamless Migration**: Export custom profiles as JSON strings for instant sharing and import across devices.

### 2. Digital Case Management
A standardized archival solution for destiny data, solving cross-platform fragmentation:
*   **Full JSON Export/Import**: Export local case libraries (including name, birth data, coordinates) as structured JSON for research or manual sync.
*   **Multi-channel Sharing**: Leverage Flutter's capabilities to share cases or profiles via files, QR codes, or the system clipboard.
*   **High-Precision Geodata**: Built-in calibrated city database for automatic timezone matching and True Solar Time correction.

### 3. Experimental: Bazi ShenSha Module
Exploring the path of transforming traditional symbolic stars into programmable logic:
*   **ShenSha Matrix**: Initial integration of core algorithms including Noble, Horse, KongWang, and KuiGang.
*   **Engineering Note**: This module is marked as "experimental" to test algorithmic robustness. Due to the vast discrepancies in rules across lineages, results are for reference only and have not undergone large-scale manual verification.

---

## 🛠️ Quick Start (Development)

### Automated Testing
Run unit tests to verify the integrity of the underlying logic:
```bash
flutter test
```

### Code Generation
This project relies on code generation (Riverpod Generator, Freezed, Json Serializable). Run this after modifying models:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Data Maintenance
The `tool/` directory contains utility scripts for processing base data, such as generating the city database:
```bash
dart run tool/generate_cities.dart
```

> 💡 For in-depth design details, Provider caching strategies, and dependency management, please refer to: **[Architecture Document (ARCHITECTURE.md)](./ARCHITECTURE.md)**.

---

## 🚀 Getting Started

### Prerequisites

*   Flutter SDK `^3.16.0` or higher
*   Dart SDK `^3.1.0` or higher

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/RedSC1/opendestiny-flutter.git
    cd opendestiny-flutter
    ```

2.  **Fetch dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run code generation (for Riverpod/Freezed)**:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the application**:
    ```bash
    flutter run
    ```

---

## 🏗️ Project Structure

```text
opendestiny-flutter/
├── android/            # Native Android runner/configuration
├── ios/                # Native iOS runner/configuration
├── assets/             # Images, fonts, and core branding assets
├── lib/
│   ├── core/           # App-wide routing, configuration, and shared settings
│   ├── data/           # Repositories, database storage, local data
│   ├── features/       # Feature-driven modules (bazi, ziwei, profile, settings)
│   ├── models/         # Global domain models (Destiny profile, etc.)
│   └── main.dart       # Application entry point
└── pubspec.yaml        # Package configurations
```

---

## 📝 Roadmap

*   [x] Establish core Astro-Engine links (`ziwei_core`, `bazi_core`)
*   [x] Publish core components to `pub.dev`.
*   [ ] Complete internal localization and multi-language support (i18n).
*   [ ] Implement advanced chart interaction (Palace popups, overlay modes).
*   [ ] Cloud synchronization mapping for saved Destiny Profiles (`Case Library`).
*   [ ] Expand into additional traditional divination modules, including Qimen Dunjia, Meihua Yishu, and Liuyao.

---

## ⚖️ Disclaimer

This software is provided for astronomical research, cultural heritage documentation, and entertainment purposes. The maintainers assume no legal responsibility for any life decisions, economic predictions, or personal actions based on the software's output.

---

## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
