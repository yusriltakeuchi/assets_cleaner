import 'dart:io';

import 'package:assets_cleaner/models/gen_model.dart';
import 'package:assets_cleaner/utils/file_utils.dart';

class CodeUtils {
  factory CodeUtils() => instance;

  CodeUtils._();

  static final CodeUtils instance = CodeUtils._();

  /// The function scans the code files located in the "lib" directory of the current project.
  Future<List<FileSystemEntity>> _scanCodes(Directory dir) async {
    List<FileSystemEntity> listFiles = [];
    final listDirs = dir.list(recursive: true);
    await listDirs.forEach((dir) {
      RegExp regExp = new RegExp("\.(dart)", caseSensitive: false);
      // Only add in List if file in path is supported
      if (regExp.hasMatch('$dir')) {
        listFiles.add(dir);
      }
    });
    return listFiles;
  }

  /// The function checks whether the asset is used in the code.
  Future<bool> containsAsset(String asset) async {
    String currentPath = FileUtils.instance.getCurrentPath;
    String libDirectory = "$currentPath/lib";
    final libCodes = await _scanCodes(Directory(libDirectory));
    for (var code in libCodes) {
      final path = code.path.replaceAll(currentPath, "");
      final content = File("$currentPath$path").readAsStringSync();
      if (content.contains(asset)) {
        return true;
      }
    }
    return false;
  }

  /// The function checks variable flutter_gen being used in the code.
  /// Exclude file with extension .gen.dart
  Future<bool> containsFlutterGenAssets(GenModel genAsset) async {
    String currentPath = FileUtils.instance.getCurrentPath;
    String libDirectory = "$currentPath/lib";
    final libCodes = await _scanCodes(Directory(libDirectory));
    for (int i = 0; i < libCodes.length; i++) {
      final path = libCodes[i].path.replaceAll(currentPath, "");
      if (path.endsWith('.gen.dart')) continue;
      final content = File("$currentPath$path").readAsStringSync();
      if (content.contains(genAsset.variable)) {
        return true;
      }
    }
    return false;
  }
}
