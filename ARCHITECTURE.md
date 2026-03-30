# 🔮 OpenDestiny-Flutter 架构设计文档

## 1. 概述 (Overview)
OpenDestiny-Flutter 是一个基于 Flutter 的通用命理排盘平台。它整合了 `bazi_core` (八字) 和 `ziwei_core` (紫微斗数) 等底层引擎，旨在提供一个现代、美观、响应式且易于扩展的命理应用。

## 2. 核心设计原则 (Design Principles)
- **计算与 UI 分离**：所有的排盘逻辑都在独立的 Dart Core 库中，Flutter 只负责展示。
- **响应式状态管理**：使用 **Riverpod** 驱动数据流，确保复杂的排盘计算在输入变化时能够自动更新。
- **高性能缓存**：利用 Riverpod 的 Provider 缓存机制，避免不必要的重复排盘计算。
- **跨平台一致性**：架构设计兼容 Android、iOS、Web 以及桌面端。

## 3. 技术栈 (Tech Stack)
- **UI 框架**: Flutter (Material 3)
- **状态管理**: Riverpod + Riverpod Generator (代码生成)
- **数据模型**: Freezed (不可变对象模型)
- **底层引擎**: 
  - `bazi_core`: 八字/四柱推算
  - `ziwei_core`: 紫微斗数推算
  - `sxwnl_spa_dart`: 高精度历法/天文计算

## 4. 文件夹架构 (Folder Structure)

采用 **Feature-first (功能优先)** 的组织方式：

```text
lib/
├── main.dart                 # 入口，ProviderScope 初始化
├── models/                   # 全局共享数据模型
│   └── birth_data.dart       # 封装出生时间、性别、地理位置等
├── providers/                # 全局基础 Provider
│   └── input_provider.dart   # 管理用户当前输入的出生信息
├── features/                 # 核心功能模块
│   ├── bazi/                 # 八字模块
│   │   ├── bazi_view.dart    # 八字 UI 界面
│   │   └── bazi_provider.dart# 逻辑：将 BirthData 转化为 BaziChart
│   └── ziwei/                # 紫微模块
│       ├── ziwei_view.dart   # UI：12宫位命盘图
│       ├── widgets/          # 宫位格子等小组件
│       └── ziwei_provider.dart # 逻辑：将 BirthData 转化为 ZiWeiPlate
└── core/                     # 通用配置、主题、工具类
```

## 5. 数据流向 (Data Flow)

1.  **用户输入**: 用户在 UI 修改 `BirthDatePicker`。
2.  **状态更新**: `InputNotifier` 捕捉到变化，更新 `BirthData` 状态。
3.  **自动重算**: 
    - `baziProvider` 监听到 `BirthData` 变化，自动调用 `bazi_core` 重新排盘。
    - `ziweiProvider` 同理，调用 `ziwei_core` 重新出盘。
4.  **UI 刷新**: `ConsumerWidget` 监听到 Provider 的新数据，触发局部刷新。

## 6. 依赖管理策略 (Dependency Strategy)

为了兼顾“多端协作”与“本地开发速度”，我们采用 **GitHub + Path Overrides** 的策略：

-   **`dependencies`**: 使用 GitHub 链接（`ref: main`）。保证了项目的可移植性，不需要频繁发布版本到 pub.dev。
-   **`dependency_overrides`**: 在本地开发环境下，强制指向本地 `../bazi_core` 等文件夹。保证了修改核心库代码后，App 可以立即看到效果，无需每次都通过 Git 发布。

## 7. 后续规划 (Roadmap)
- [x] **基础架构搭建**：Riverpod + Freezed 环境。
- [ ] **基础排盘接入**：打通 `BirthData` -> `BaziChart` 的链路。
- [ ] **八字 UI 视图**：实现四柱、大运、流年的展示。
- [ ] **紫微 12 宫格**：实现响应式命盘布局。
- [ ] **真太阳时集成**：接入经纬度换算逻辑。
