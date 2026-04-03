import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:file_selector/file_selector.dart' hide XFile;
import 'package:share_plus/share_plus.dart';

class JsonTextTransfer {
  static const XTypeGroup _jsonTypeGroup = XTypeGroup(
    label: 'JSON',
    extensions: <String>['json'],
    mimeTypes: <String>['application/json', 'text/json'],
    uniformTypeIdentifiers: <String>['public.json'],
  );

  Future<String?> pickJsonText() async {
    final file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[_jsonTypeGroup],
    );
    if (file == null) {
      return null;
    }
    return file.readAsString();
  }

  Future<void> exportJsonText({
    required String fileName,
    required String jsonText,
  }) async {
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: Uint8List.fromList(utf8.encode(jsonText)),
      fileExtension: 'json',
      mimeType: MimeType.json,
    );
  }

  Future<void> shareJsonText({
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
            name: '$fileName.json',
          ),
        ],
        fileNameOverrides: <String>['$fileName.json'],
        title: 'OpenDestiny JSON',
        subject: 'OpenDestiny JSON',
        downloadFallbackEnabled: true,
      ),
    );
  }

  String sanitizeFileName(String value) {
    final sanitized = value
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
    return sanitized.isEmpty ? 'json' : sanitized;
  }
}
