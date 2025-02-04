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

  /// Reads the pubspec.yaml file and returns a list of assets.
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

  /// Read flutter_gen on pubspec.yaml and read output path
  /// outside 'flutter' key
  Future<String> getFlutterGenPath() async {
    final pubspecFile = File(_getPubspecPath);
    if (await pubspecFile.exists() == true) {
      final YamlMap map = loadYaml(pubspecFile.readAsStringSync()) as YamlMap;
      final dynamic flutterGenMap = map['flutter_gen'];
      if (flutterGenMap is YamlMap) {
        final dynamic outputMap = flutterGenMap['output'];
        if (outputMap is String) {
          return outputMap;
        }
      }
    } else {
      print("[🚫] pubspec.yaml file not found");
    }
    return "";
  }

  /// Takes a file path as input and returns the path without the
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

  /// returns the filename from a given path.
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

  /// Get list of excluded folder from config
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

  /// Retrieve all asset files, including diving deep if there are folders inside
  Future<List<FileSystemEntity>> loadAssets(String assetsPath) async {
    final dir = Directory("${getCurrentPath}/$assetsPath");
    final List<FileSystemEntity> entities = [];
    if (await dir.exists()) {
      final List<FileSystemEntity> list = await dir.list().toList();

      for (var entity in list) {
        if (entity is File && entity.uri.pathSegments.last.contains('.')) {
          entities.add(entity);
        } else if (entity is Directory) {
          final List<FileSystemEntity> subEntities = await loadAssets(
            entity.path.replaceAll("$getCurrentPath/", ""),
          );
          entities.addAll(subEntities);
        }
      }
    } else {
      print('Directory does not exist: ${dir.path}');
    }

    return entities;
  }

  /// Move file to trash folder
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
