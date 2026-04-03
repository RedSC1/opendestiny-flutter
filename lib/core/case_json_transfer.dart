import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:file_selector/file_selector.dart' hide XFile;
import 'package:share_plus/share_plus.dart';

import '../models/destiny_profile.dart';

class CaseJsonTransfer {
  static const XTypeGroup _jsonTypeGroup = XTypeGroup(
    label: 'JSON',
    extensions: <String>['json'],
    mimeTypes: <String>['application/json', 'text/json'],
    uniformTypeIdentifiers: <String>['public.json'],
  );

  Future<void> exportCase(DestinyCase caseData) async {
    final payload = _singleCasePayload(caseData);
    await _saveJsonFile(
      fileName: 'opendestiny_case_${_sanitizeFileName(caseData.name)}',
      jsonText: const JsonEncoder.withIndent('  ').convert(payload),
    );
  }

  Future<void> exportCases(List<DestinyCase> cases) async {
    final payload = _multiCasePayload(cases);
    await _saveJsonFile(
      fileName: 'opendestiny_cases_${DateTime.now().toIso8601String().split('T').first}',
      jsonText: const JsonEncoder.withIndent('  ').convert(payload),
    );
  }

  Future<void> shareCase(DestinyCase caseData) async {
    final jsonText = const JsonEncoder.withIndent('  ').convert(
      _singleCasePayload(caseData),
    );
    await _shareJsonFile(
      fileName: 'opendestiny_case_${_sanitizeFileName(caseData.name)}.json',
      jsonText: jsonText,
    );
  }

  Future<void> shareCases(List<DestinyCase> cases) async {
    final jsonText = const JsonEncoder.withIndent('  ').convert(
      _multiCasePayload(cases),
    );
    final fileName =
        'opendestiny_cases_${DateTime.now().toIso8601String().split('T').first}.json';
    await _shareJsonFile(fileName: fileName, jsonText: jsonText);
  }

  Future<List<DestinyCase>> pickCasesFromJson() async {
    final file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[_jsonTypeGroup],
    );
    if (file == null) {
      return const <DestinyCase>[];
    }

    final jsonText = await file.readAsString();
    return parseCasesJson(jsonText);
  }

  List<DestinyCase> parseCasesJson(String jsonText) {
    final decoded = jsonDecode(jsonText);
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((item) => DestinyCase.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false);
    }

    if (decoded is! Map) {
      throw const FormatException('JSON 根节点必须是对象或数组');
    }

    final map = Map<String, dynamic>.from(decoded);
    final format = map['format'];
    if (format == 'opendestiny_case_v1' && map['data'] is Map) {
      return <DestinyCase>[
        DestinyCase.fromJson(Map<String, dynamic>.from(map['data'] as Map)),
      ];
    }

    if (format == 'opendestiny_cases_v1' && map['cases'] is List) {
      return (map['cases'] as List)
          .whereType<Map>()
          .map((item) => DestinyCase.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false);
    }

    if (map['cases'] is List) {
      return (map['cases'] as List)
          .whereType<Map>()
          .map((item) => DestinyCase.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false);
    }

    if (map['birthInput'] is Map) {
      return <DestinyCase>[DestinyCase.fromJson(map)];
    }

    throw const FormatException('不支持的命例 JSON 格式');
  }

  Future<void> _saveJsonFile({
    required String fileName,
    required String jsonText,
  }) async {
    final bytes = Uint8List.fromList(utf8.encode(jsonText));
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      fileExtension: 'json',
      mimeType: MimeType.json,
    );
  }

  Future<void> _shareJsonFile({
    required String fileName,
    required String jsonText,
  }) async {
    final bytes = Uint8List.fromList(utf8.encode(jsonText));
    await SharePlus.instance.share(
      ShareParams(
        files: <XFile>[
          XFile.fromData(
            bytes,
            mimeType: 'application/json',
            name: fileName,
          ),
        ],
        fileNameOverrides: <String>[fileName],
        title: 'OpenDestiny JSON',
        subject: 'OpenDestiny JSON',
        downloadFallbackEnabled: true,
      ),
    );
  }

  String _sanitizeFileName(String value) {
    final sanitized = value
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
    return sanitized.isEmpty ? 'case' : sanitized;
  }

  Map<String, dynamic> _singleCasePayload(DestinyCase caseData) {
    return <String, dynamic>{
      'format': 'opendestiny_case_v1',
      'exportedAt': DateTime.now().toIso8601String(),
      'data': caseData.toJson(),
    };
  }

  Map<String, dynamic> _multiCasePayload(List<DestinyCase> cases) {
    return <String, dynamic>{
      'format': 'opendestiny_cases_v1',
      'exportedAt': DateTime.now().toIso8601String(),
      'count': cases.length,
      'cases': cases.map((item) => item.toJson()).toList(growable: false),
    };
  }
}
