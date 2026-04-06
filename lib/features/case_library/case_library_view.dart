import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/case_json_transfer.dart';
import '../../providers/input_provider.dart';
import '../../core/l10n.dart';
import '../profile/profile_view.dart';

class CaseLibraryView extends ConsumerWidget {
  const CaseLibraryView({super.key});

  static final CaseJsonTransfer _jsonTransfer = CaseJsonTransfer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCase = ref.watch(currentCaseProvider);
    final caseSummaries = ref.watch(caseSummariesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('案例库'.tr),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: '导入 JSON'.tr,
            icon: const Icon(Icons.file_open_outlined),
            onPressed: () => _importCases(context, ref),
          ),
          IconButton(
            tooltip: '分享全部 JSON'.tr,
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareAllCases(context, ref),
          ),
          IconButton(
            tooltip: '导出全部 JSON'.tr,
            icon: const Icon(Icons.download_outlined),
            onPressed: () => _exportAllCases(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await ref.read(inputNotifierProvider.notifier).selectCase(null);
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileView()),
                  );
                }
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.78),
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '当前时间'.tr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '未存档草稿'.tr,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: caseSummaries.length,
              itemBuilder: (context, index) {
                final item = caseSummaries[index];
                final selected = currentCase.id == item.id;
                return _CaseListTile(
                  title: item.name,
                  subtitle: item.getSubtitle(ref.watch(appSettingsProvider).useAstronomicalYear),
                  selected: selected,
                  onTap: () async {
                    await ref.read(inputNotifierProvider.notifier).selectCase(item.id);
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileView()),
                      );
                    }
                  },
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('删除案例'.tr),
                        content: Text('${'确定要删除「'.tr}${item.name}${'」吗？'.tr}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('取消'.tr),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('删除'.tr, style: const TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await ref.read(inputNotifierProvider.notifier).deleteCase(item.id);
                    }
                  },
                  onShare: () => _shareCase(context, ref, item.id),
                  onExport: () => _exportCase(context, ref, item.id),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await ref.read(inputNotifierProvider.notifier).createNewCase();
          // 强制重置导航到“编辑资料”页 (index 0)
          ref.read(navigationIndexProvider.notifier).state = 0;
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileView()),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: Text('新建案例'.tr),
      ),
    );
  }

  Future<void> _importCases(BuildContext context, WidgetRef ref) async {
    try {
      final cases = await _jsonTransfer.pickCasesFromJson();
      if (cases.isEmpty) {
        return;
      }
      final count = await ref.read(inputNotifierProvider.notifier).importCases(cases);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'已导入'.tr} $count ${'个命例'.tr}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'导入失败：'.tr}$e')),
        );
      }
    }
  }

  Future<void> _exportAllCases(BuildContext context, WidgetRef ref) async {
    try {
      final cases = await ref.read(inputNotifierProvider.notifier).getSavedCases();
      if (cases.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('当前没有可导出的命例'.tr)),
          );
        }
        return;
      }
      await _jsonTransfer.exportCases(cases);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'已导出'.tr} ${cases.length} ${'个命例'.tr}，${_exportLocationHint()}'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'导出失败：'.tr}$e')),
        );
      }
    }
  }

  Future<void> _shareAllCases(BuildContext context, WidgetRef ref) async {
    try {
      final cases = await ref.read(inputNotifierProvider.notifier).getSavedCases();
      if (cases.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('当前没有可分享的命例'.tr)),
          );
        }
        return;
      }
      await _jsonTransfer.shareCases(cases);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'已打开分享面板'.tr} ${cases.length} ${'个命例'.tr}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'分享失败：'.tr}$e')),
        );
      }
    }
  }

  Future<void> _exportCase(BuildContext context, WidgetRef ref, String id) async {
    try {
      final caseData = await ref.read(inputNotifierProvider.notifier).getCaseById(id);
      if (caseData == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('命例不存在或已删除'.tr)),
          );
        }
        return;
      }
      await _jsonTransfer.exportCase(caseData);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'已导出命例：'.tr}${caseData.name}，${_exportLocationHint()}'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'导出失败：'.tr}$e')),
        );
      }
    }
  }

  Future<void> _shareCase(BuildContext context, WidgetRef ref, String id) async {
    try {
      final caseData = await ref.read(inputNotifierProvider.notifier).getCaseById(id);
      if (caseData == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('命例不存在或已删除'.tr)),
          );
        }
        return;
      }
      await _jsonTransfer.shareCase(caseData);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'已打开分享面板：'.tr}${caseData.name}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'分享失败：'.tr}$e')),
        );
      }
    }
  }

  String _exportLocationHint() {
    if (kIsWeb) {
      return '请到浏览器下载目录查看'.tr;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return '请到“文件”App 中查看'.tr;
      case TargetPlatform.android:
        return '请到系统下载目录查看'.tr;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return '请到下载目录查看'.tr;
      case TargetPlatform.fuchsia:
        return '请检查系统保存位置'.tr;
    }
  }
}

class _CaseListTile extends StatelessWidget {
  const _CaseListTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.onDelete,
    required this.onShare,
    required this.onExport,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<_CaseMenuAction>(
                  icon: Icon(
                    Icons.more_vert,
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade700,
                  ),
                  onSelected: (action) {
                    switch (action) {
                      case _CaseMenuAction.share:
                        onShare();
                        break;
                      case _CaseMenuAction.export:
                        onExport();
                        break;
                      case _CaseMenuAction.delete:
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry<_CaseMenuAction>>[
                    PopupMenuItem<_CaseMenuAction>(
                      value: _CaseMenuAction.share,
                      child: Text('分享 JSON'.tr),
                    ),
                    PopupMenuItem<_CaseMenuAction>(
                      value: _CaseMenuAction.export,
                      child: Text('导出 JSON'.tr),
                    ),
                    PopupMenuItem<_CaseMenuAction>(
                      value: _CaseMenuAction.delete,
                      child: Text('删除'.tr),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _CaseMenuAction { share, export, delete }
