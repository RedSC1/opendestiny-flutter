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

**OpenDestiny** (开源命运/术数引擎应用) is a beautifully crafted, cross-platform Flutter application dedicated to generating highly accurate traditional Chinese astrological charts, primarily focusing on **Bazi (Four Pillars of Destiny)** and **Ziwei Doushu (Purple Star Astrology)**.

Building on top of an immensely powerful, thoroughly decoupled set of pure Dart engines (`sxwnl_spa_dart`, `bazi_core`, `ziwei_core`), OpenDestiny boasts a massive 6,000-year algorithmic timeline tracking capabilities, offering researchers, practitioners, and enthusiasts a modern, blazing-fast, and completely offline computational platform.

---

## ✨ Core Features

*   **🌌 Professional Ziwei Doushu & Bazi Integration**
    *   Generates accurate Heaven (天盘), Earth (地盘), and Human (人盘) plates.
    *   Dynamic flows (Decade, Year, Month, Day, Hour) powered by a robust state machine mechanism.
    *   High-precision ephemeris astronomical calendar computations including True Solar Time (Apparent Solar Time) correction.
*   **🎨 Stunning UI & UX**
    *   Built cleanly with modern Material Design principles combined with specialized traditional chart layout algorithms.
    *   Responsive and dynamically auto-scaling dashboard UI designed to avoid display overlapping on mobile screens.
*   **📐 Architectural Excellence**
    *   State management strictly controlled by `Riverpod` + `Freezed`.
    *   Clean separation of UI rendering and underlying astrological logic calculations.
    *   Fast, type-safe data serialization with `json_serializable`.
*   **🌐 True Cross-Platform Capabilities**
    *   Supports Android, iOS, Windows, macOS, Linux, and Web directly out of the box with zero native-code dependencies.

---

## 🏛️ Ecosystem Architecture

OpenDestiny serves as the polished, client-facing flagship for a suite of underlying open-source Dart libraries:

1.  📦 **[`sxwnl_spa_dart`](https://pub.dev/packages/sxwnl_spa_dart)** (v0.16.0) - High-precision **astronomical** and solar term computations.
2.  📦 **[`bazi_core`](https://pub.dev/packages/bazi_core)** (v0.6.0) - The primary engine for Lunar calculations, Bazi pillars, and Si Ling.
3.  📦 **[`ziwei_core`](https://pub.dev/packages/ziwei_core)** (v0.11.0) - The core rule-engine for plotting Ziwei Doushu charts.

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
