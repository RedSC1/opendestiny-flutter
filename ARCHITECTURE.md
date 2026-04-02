# 🔮 OpenDestiny 架构设计

## 1. 核心设计原则
- **计算逻辑解耦**：所有排盘与推演算法均封装在独立的 `*_core` 库中，Flutter 端仅作为状态消费者与 UI 渲染器。
- **声明式数据流**：利用 `Riverpod` 建立响应式链条。输入端（BirthData）变更后，下游所有排盘 Provider 会自动触发重新计算。
- **按需计算与缓存**：Provider 仅在活跃视图订阅时进行计算，并利用内存缓存避免重复执行复杂的星曜安星逻辑。

## 2. 技术栈
- **UI 层**: Flutter (Material 3)
- **状态管理**: Riverpod (Generator 驱动)
- **数据模型**: Freezed (不可变模型 + 序列化)
- **算法层**: `bazi_core`, `ziwei_core`, `sxwnl_spa_dart`

## 3. 目录组织 (Feature-first)

```text
lib/
├── main.dart                 # App 启动入口，ProviderScope 容器根
├── models/                   # 跨模块共享的领域实体 (BirthData, DestinyProfile)
├── providers/                # 全局基础 Provider (如：管理当前选中的排盘对象)
├── data/                     # 静态数据与本地存储映射
├── core/                     # 主题配置、常量定义、底层工具类
└── features/                 # 业务功能模块
    ├── bazi/                 # 八字模块：UI 连线及 Provider 适配
    ├── ziwei/                # 紫微模块：12 宫格布局与动态状态机
    ├── profile/              # 用户档案管理逻辑
    └── settings/             # 系统配置 (真太阳时、语言等)
```

## 4. 数据流向示例 (Data Flow)

1. **输入阶段**: 用户通过 UI 交互修改 `BirthData` (如：调整出生经纬度)。
2. **逻辑穿透**: 
   - `inputProvider` 状态变更。
   - `baziProvider` / `ziweiProvider` 自动感知上游变更。
   - 触发底层 Core 库执行排盘算法。
3. **状态同步**: 新的不可变模型 (Chart/Plate) 被推送到 UI，`ConsumerWidget` 执行局部重绘。

## 5. 依赖管理策略 (Dependency Strategy)

为确保环境的一致性与发布的稳定性，项目采用以下依赖方案：

- **版本锁定**: 核心库（`bazi_core`, `ziwei_core`, `sxwnl_spa_dart`）通过 `pub.dev` 进行版本分发，项目采用语义化版本（SemVer）进行锁定，确保多端构建的复现性。
- **本地调试 (开发态)**: 在涉及核心算法迭代时，可通过 `pubspec.yaml` 的 `dependency_overrides` 临时映射至本地核心库目录，实现 App 与算法库的无缝同步调试，无需频繁发布预发布版。
