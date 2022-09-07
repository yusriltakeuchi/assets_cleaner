import 'dart:io';
import 'package:yaml/yaml.dart';

class FileUtils {
  factory FileUtils() => _instance;
  FileUtils._();

  static late final FileUtils _instance = FileUtils._();
  String getCurrentPath() => Directory.current.absolute.path;
  String _getPubspecPath() => "${getCurrentPath()}/pubspec.yaml";
  String _configFilePath() => "${getCurrentPath()}/assets_cleaner.yaml";
  YamlMap? config;

  /// Get list of assets path from pubspec.yaml
  Future<List<String>> getPubspecAsset() async {
    final pubspecFile = File(_getPubspecPath());
    if (await pubspecFile.exists() == true) {
      final YamlMap map = loadYaml(pubspecFile.readAsStringSync()) as YamlMap;
      final dynamic flutterMap = map['flutter'];
      if (flutterMap is YamlMap) {
        final dynamic assetMap = flutterMap['assets'];
        if (assetMap is YamlList) {
          return _getListFromYamlList(assetMap);
        } else {
        }
      }
    } else {
      print("[🚫] pubspec.yaml file not found");
    }
    return <String>[];
  }

  /// Get config from assets_cleaner.yaml
  void getConfig() {
    final configFile = File(_configFilePath());
    if (configFile.existsSync() == true) {
      final YamlMap map = loadYaml(configFile.readAsStringSync()) as YamlMap;
      config = map['config'];
    } else {
      print("[🚫] assets_cleaner.yaml file not found");
    }
  }

  /// Get list of excluded extensions from config
  List<String> getExcludeExtension() => config?['exclude-extension'] != null ? _getListFromYamlList(config?['exclude-extension'] as YamlList) : [];
  /// Get list of excluded file from config
  List<String> getExcludeFile() => config?['exclude-file'] != null ? _getListFromYamlList(config?['exclude-file'] as YamlList) : [];

  /// Get list data from yaml list
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

  /// Load all assets from path
  Future<List<FileSystemEntity>> loadAssets(String assetsPath) async {
    final dir = Directory("${getCurrentPath()}/$assetsPath");
    final List<FileSystemEntity> entities = await dir.list().toList();
    return entities;
  }

}