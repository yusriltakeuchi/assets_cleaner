import 'dart:io';

import 'package:assets_cleaner/utils/file_utils.dart';

class CodeUtils {
  factory CodeUtils() => instance;
  CodeUtils._();
  static final CodeUtils instance = CodeUtils._();

  /// The function `_scanCodes` scans a directory and returns a list of all the Dart files found in that
  /// directory and its subdirectories.
  ///
  /// Arguments:
  ///
  /// * `dir`: The `dir` parameter is a `Directory` object representing the directory that needs to be
  /// scanned for files.
  ///
  /// Returns:
  ///
  /// The function `_scanCodes` returns a `Future` that resolves to a `List` of `FileSystemEntity`
  /// objects.
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

  /// The function checks if a given asset is present in the code files located in the "lib" directory
  /// of the current project.
  ///
  /// Arguments:
  ///
  /// * `asset`: The `asset` parameter is a string that represents the name or identifier of an asset
  /// that we want to check for in the code files.
  ///
  /// Returns:
  ///
  /// The method `containsAsset` returns a `Future<bool>`.
  Future<bool> containsAsset(String asset) async {
    String currentPath = FileUtils.instance.getCurrentPath;
    String libDirectory = "$currentPath/lib";
    final libCodes = await _scanCodes(Directory(libDirectory));

    for (var code in libCodes) {
      final path = code.path.replaceAll(currentPath, "");
      final content = File("$currentPath$path").readAsStringSync();
      return content.contains(asset);
    }
    return false;
  }
}
