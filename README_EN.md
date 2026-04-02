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

1.  📦 **[`sxwnl_spa_dart`](https://pub.dev/packages/sxwnl_spa_dart)** (v0.16.0): High-precision astronomical calendar and solar term computations.
2.  📦 **[`bazi_core`](https://pub.dev/packages/bazi_core)** (v0.6.0): The logic engine for Bazi pillars, luck cycles, and interactions.
3.  📦 **[`ziwei_core`](https://pub.dev/packages/ziwei_core)** (v0.11.0): The rule-engine for plotting Ziwei Doushu star positions and transformations.

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

## 🧪 Quality & Development

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

---

## ⚖️ Disclaimer

This software is provided for astronomical research, cultural heritage documentation, and entertainment purposes. The maintainers assume no legal responsibility for any life decisions, economic predictions, or personal actions based on the software's output.

---

## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
