import 'dart:io';
import 'package:yaml/yaml.dart';

class FileUtils {
  factory FileUtils() => instance;
  FileUtils._();

  static final FileUtils instance = FileUtils._();
  String get getCurrentPath => Directory.current.absolute.path
      .replaceAll(r'\', '/')
      .replaceAll('//', '/');
  String get _getPubspecPath => "${getCurrentPath}/pubspec.yaml";
  String get _configFilePath => "${getCurrentPath}/assets_cleaner.yaml";
  YamlMap? config;

  /// The function `getPubspecAsset` reads the `pubspec.yaml` file and returns a list of assets
  /// specified in the `flutter` section.
  ///
  /// Returns:
  ///
  /// The method `getPubspecAsset()` returns a `Future` object that resolves to a `List` of `String`
  /// values.
  Future<List<String>> getPubspecAsset() async {
    final pubspecFile = File(_getPubspecPath);
    if (await pubspecFile.exists() == true) {
      final YamlMap map = loadYaml(pubspecFile.readAsStringSync()) as YamlMap;
      final dynamic flutterMap = map['flutter'];
      if (flutterMap is YamlMap) {
        final dynamic assetMap = flutterMap['assets'];
        if (assetMap is YamlList) {
          List<String> assets = _getListFromYamlList(assetMap);
          assets = assets.map((e) => clearFileNameFromPath(e)).toList();
          return assets;
        } else {}
      }
    } else {
      print("[🚫] pubspec.yaml file not found");
    }
    return <String>[];
  }

  /// The function `clearFileNameFromPath` takes a file path as input and removes the file name from it,
  /// returning the modified path.
  ///
  /// Arguments:
  ///
  /// * `path`: The `path` parameter is a string that represents a file path.
  ///
  /// Returns:
  ///
  /// The method `clearFileNameFromPath` returns a string.
  String clearFileNameFromPath(String path) {
    final fileName = _getFileNameFromPath(path);
    if (fileName != null) {
      return path
          .replaceAll(fileName, "")
          .replaceAll("$fileName/", "")
          .replaceAll("//", "/");
    } else {
      return path;
    }
  }

  /// The function `_getFileNameFromPath` takes a file path as input and returns the filename if it
  /// exists, otherwise it returns null.
  ///
  /// Arguments:
  ///
  /// * `path`: The `path` parameter is a string that represents a file path.
  ///
  /// Returns:
  ///
  /// a String value.
  String? _getFileNameFromPath(String path) {
    // Split path into a list of directories and filename
    List<String> pathComponents = path.split('/');
    // Get the last component of the path, which should be the filename
    String fileName = pathComponents.last;
    // Check if the filename is empty or if it contains only a dot
    if (fileName.isEmpty || fileName == '.') {
      if (pathComponents[pathComponents.length - 2].contains(".")) {
        return pathComponents[pathComponents.length - 2].replaceAll("/", "");
      }

      return null;
    }
    if (fileName.contains(".")) {
      return fileName;
    }
    return null;
  }

  /// The getConfig function reads a YAML file and assigns the value of the 'config' key to the config
  /// variable.
  void getConfig() {
    final configFile = File(_configFilePath);
    if (configFile.existsSync() == true) {
      final YamlMap map = loadYaml(configFile.readAsStringSync()) as YamlMap;
      config = map['config'];
    } else {
      print("[🚫] assets_cleaner.yaml file not found");
    }
  }

  /// Get list of excluded extensions from config
  List<String> getExcludeExtension() => config?['exclude-extension'] != null
      ? _getListFromYamlList(config?['exclude-extension'] as YamlList)
      : [];

  /// Get list of excluded file from config
  List<String> getExcludeFile() => config?['exclude-file'] != null
      ? _getListFromYamlList(config?['exclude-file'] as YamlList)
      : [];

  /// The function `_getListFromYamlList` converts a `YamlList` to a `List<String>`.
  ///
  /// Arguments:
  ///
  /// * `yamlList`: A YamlList object, which is a list of dynamic values in YAML format.
  ///
  /// Returns:
  ///
  /// The method is returning a List<String>.
  List<String> _getListFromYamlList(YamlList yamlList) {
    final List<String> list = <String>[];
    final List<String> r = yamlList.map((dynamic f) {
      return f.toString();
    }).toList();
    list.addAll(r);
    return list;
  }

  /// Delete file from path
  void deleteFile(String path) {
    final file = File(path);
    if (file.existsSync() == true) {
      file.deleteSync();
    }
  }

  /// The function `loadAssets` loads all assets from a specified path and returns a list of
  /// `FileSystemEntity` objects.
  ///
  /// Arguments:
  ///
  /// * `assetsPath`: The `assetsPath` parameter is a string that represents the path to the directory
  /// where the assets are located.
  ///
  /// Returns:
  ///
  /// a Future that resolves to a List of FileSystemEntity objects.
  Future<List<FileSystemEntity>> loadAssets(String assetsPath) async {
    final dir = Directory("${getCurrentPath}/$assetsPath");
    final List<FileSystemEntity> entities = await dir.list().toList();
    return entities;
  }

  /// The function `moveToTrash` moves a file to a trash directory by renaming it.
  ///
  /// Arguments:
  ///
  /// * `path`: The `path` parameter is a string that represents the file or directory path that you
  /// want to move to the trash.
  Future<void> moveToTrash(String path) async {
    final sourceFile = File("${getCurrentPath}/$path");
    final trashDir = Directory("${getCurrentPath}/trash");
    if (await trashDir.exists() == false) {
      trashDir.create();
    }
    if (await sourceFile.exists()) {
      sourceFile.renameSync(
        "${trashDir.path}/${sourceFile.path.split('/').last}",
      );
    }
  }
}
