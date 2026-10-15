import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class SavedJobsStore {
  static final ValueNotifier<Set<String>> savedIds = ValueNotifier({});
  static bool _initialized = false;

  static const String _fileName = 'saved_jobs.txt';

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  static Future<void> init() async {
    if (_initialized) return;
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final ids = content
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toSet();
        savedIds.value = ids;
      }
      _initialized = true;
    } catch (_) {}
  }

  static bool isSaved(String id) => savedIds.value.contains(id);

  static void toggle(String id) {
    final s = Set<String>.from(savedIds.value);
    if (!s.remove(id)) s.add(id);
    savedIds.value = s;
    _saveToFile(s);
  }

  static Future<void> _saveToFile(Set<String> ids) async {
    try {
      final file = await _getFile();
      await file.writeAsString(ids.join('\n'), flush: true);
    } catch (_) {}
  }
}
