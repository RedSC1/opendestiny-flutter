import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'app_version.dart';
import 'l10n.dart';

class AppUpdateInfo {
  const AppUpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.message,
    required this.critical,
    required this.githubUrl,
    required this.giteeUrl,
    required this.gitcodeUrl,
  });

  final String currentVersion;
  final String latestVersion;
  final String message;
  final bool critical;
  final String githubUrl;
  final String giteeUrl;
  final String gitcodeUrl;

  bool get hasUpdate =>
      _compareVersions(latestVersion, currentVersion) > 0;

  List<_UpdateLink> get links => [
    if (githubUrl.trim().isNotEmpty)
      _UpdateLink('前往 GitHub Release'.tr, githubUrl),
    if (giteeUrl.trim().isNotEmpty) _UpdateLink('Gitee 镜像'.tr, giteeUrl),
    if (gitcodeUrl.trim().isNotEmpty) _UpdateLink('GitCode 镜像'.tr, gitcodeUrl),
  ];

  factory AppUpdateInfo.fromJson(Map<String, dynamic> json) {
    return AppUpdateInfo(
      currentVersion: AppVersion.current,
      latestVersion: (json['version'] ?? '').toString().trim(),
      message: (json['message'] ?? '').toString().trim(),
      critical: json['critical'] == true,
      githubUrl: _resolvedUrl(
        json['githubUrl'],
        fallback: AppUpdateService.githubReleaseUrl,
      ),
      giteeUrl: _resolvedUrl(
        json['giteeUrl'],
        fallback: AppUpdateService.giteeReleaseUrl,
      ),
      gitcodeUrl: _resolvedUrl(
        json['gitcodeUrl'],
        fallback: AppUpdateService.gitcodeReleaseUrl,
      ),
    );
  }

  static String _resolvedUrl(Object? value, {required String fallback}) {
    final text = (value ?? '').toString().trim();
    return text.isEmpty ? fallback : text;
  }
}

class AppUpdateService {
  static const String versionJsonUrl =
      'https://opendestiny.redsc1.com/version.json';
  static const String githubReleaseUrl =
      'https://github.com/RedSC1/opendestiny-flutter/releases/latest';
  static const String giteeReleaseUrl =
      'https://gitee.com/RedSC1/opendestiny-flutter';
  static const String gitcodeReleaseUrl =
      'https://gitcode.com/RedSC/opendestiny-flutter';

  static Future<AppUpdateInfo?> fetchLatestInfo({
    int retryCount = 3,
  }) async {
    if (kIsWeb) return null;

    final uri = Uri.parse(versionJsonUrl);
    for (var attempt = 0; attempt < retryCount; attempt += 1) {
      try {
        final response = await http
            .get(
              uri.replace(
                queryParameters: {
                  ...uri.queryParameters,
                  'ts': DateTime.now().millisecondsSinceEpoch.toString(),
                },
              ),
              headers: const {'cache-control': 'no-cache'},
            )
            .timeout(const Duration(seconds: 5));
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) {
            final info = AppUpdateInfo.fromJson(decoded);
            if (info.latestVersion.isNotEmpty) {
              return info;
            }
          }
        }
      } catch (_) {
        // Ignore transient failures and retry a few times.
      }

      if (attempt < retryCount - 1) {
        await Future<void>.delayed(const Duration(milliseconds: 1200));
      }
    }

    return null;
  }

  static Future<void> checkAndShowDialog(
    BuildContext context, {
    bool silentIfLatest = true,
    bool silentIfError = true,
  }) async {
    if (kIsWeb) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    final info = await fetchLatestInfo();

    if (!context.mounted) return;

    if (info == null) {
      if (!silentIfError && messenger != null) {
        messenger.showSnackBar(
          SnackBar(content: Text('检查更新失败'.tr)),
        );
      }
      return;
    }

    if (!info.hasUpdate) {
      if (!silentIfLatest && messenger != null) {
        messenger.showSnackBar(
          SnackBar(content: Text('已是最新版本'.tr)),
        );
      }
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(info.critical ? '发现重大更新'.tr : '发现新版本'.tr),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${'当前版本'.tr} ${info.currentVersion}'),
              const SizedBox(height: 6),
              Text('${'最新版本'.tr} ${info.latestVersion}'),
              if (info.message.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  '更新内容'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(info.message),
              ],
              const SizedBox(height: 12),
              Text(
                'GitHub 为主发布源，国内访问不稳定时可尝试备用镜像。'.tr,
                style: Theme.of(dialogContext).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('稍后'.tr),
          ),
          for (final link in info.links)
            TextButton(
              onPressed: () async {
                final ok = await _launch(link.url);
                if (!dialogContext.mounted) return;
                if (!ok) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('无法打开更新链接'.tr)),
                  );
                  return;
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(link.label),
            ),
        ],
      ),
    );
  }

  static Future<bool> _launch(String rawUrl) async {
    final url = Uri.tryParse(rawUrl);
    if (url == null) return false;
    return launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

class _UpdateLink {
  const _UpdateLink(this.label, this.url);

  final String label;
  final String url;
}

int _compareVersions(String left, String right) {
  final leftParts = _versionParts(left);
  final rightParts = _versionParts(right);
  final length = leftParts.length > rightParts.length
      ? leftParts.length
      : rightParts.length;
  for (var i = 0; i < length; i += 1) {
    final leftValue = i < leftParts.length ? leftParts[i] : 0;
    final rightValue = i < rightParts.length ? rightParts[i] : 0;
    if (leftValue != rightValue) {
      return leftValue.compareTo(rightValue);
    }
  }
  return 0;
}

List<int> _versionParts(String version) {
  final sanitized = version.split('+').first;
  final matches = RegExp(r'\d+').allMatches(sanitized);
  return matches.map((match) => int.parse(match.group(0)!)).toList();
}
