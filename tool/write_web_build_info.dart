import 'dart:convert';
import 'dart:io';

void main() {
  final root = Directory.current;
  final pubspecFile = File(_path(root.path, 'pubspec.yaml'));
  if (!pubspecFile.existsSync()) {
    stderr.writeln('pubspec.yaml not found in ${root.path}');
    exitCode = 1;
    return;
  }

  final pubspec = pubspecFile.readAsStringSync();
  final appVersion = _parseAppVersion(pubspec);
  if (appVersion == null) {
    stderr.writeln('Failed to resolve app version from pubspec.yaml');
    exitCode = 1;
    return;
  }

  final buildInfo = <String, dynamic>{
    'version': appVersion,
    'webBuild': _resolveWebBuild(appVersion),
    'commit': _resolveCommit(),
    'builtAt': DateTime.now().toUtc().toIso8601String(),
  };

  final webDir = Directory(_path(root.path, 'web'));
  if (!webDir.existsSync()) {
    stderr.writeln('web directory not found in ${root.path}');
    exitCode = 1;
    return;
  }

  File(
    _path(webDir.path, 'build_info.js'),
  ).writeAsStringSync('window.__OD_BUILD_INFO__ = ${jsonEncode(buildInfo)};\n');
  File(
    _path(webDir.path, 'version.json'),
  ).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(buildInfo));

  stdout.writeln(
    'Wrote web build info for $appVersion (${buildInfo['webBuild']})',
  );
}

String _path(String base, String name) => '$base${Platform.pathSeparator}$name';

String? _parseAppVersion(String pubspec) {
  final match = RegExp(
    r'^version:\s*([0-9]+\.[0-9]+\.[0-9]+)',
    multiLine: true,
  ).firstMatch(pubspec);
  return match?.group(1);
}

String _resolveWebBuild(String appVersion) {
  final envBuild = Platform.environment['OD_WEB_BUILD']?.trim();
  if (envBuild != null && envBuild.isNotEmpty) {
    return envBuild;
  }

  final commit = _resolveCommit();
  final timestamp = _timestamp(DateTime.now().toUtc());
  if (commit.isEmpty) {
    return '$appVersion+$timestamp';
  }
  return '$appVersion+$timestamp-$commit';
}

String _resolveCommit() {
  final envSha = Platform.environment['GITHUB_SHA']?.trim();
  if (envSha != null && envSha.isNotEmpty) {
    return envSha.substring(0, envSha.length >= 7 ? 7 : envSha.length);
  }

  try {
    final result = Process.runSync('git', const [
      'rev-parse',
      '--short',
      'HEAD',
    ]);
    if (result.exitCode == 0) {
      final value = (result.stdout as String).trim();
      if (value.isNotEmpty) return value;
    }
  } catch (_) {
    // Ignore and fall back to an empty commit marker.
  }
  return '';
}

String _timestamp(DateTime value) {
  String two(int input) => input.toString().padLeft(2, '0');
  return '${value.year}${two(value.month)}${two(value.day)}${two(value.hour)}${two(value.minute)}${two(value.second)}';
}
