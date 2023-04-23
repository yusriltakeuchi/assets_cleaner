import 'package:assets_cleaner/models/unused_asset_model.dart';
import 'package:assets_cleaner/utils/code_utils.dart';
import 'package:assets_cleaner/utils/file_utils.dart';

class AssetServices {
  factory AssetServices() => instance;
  AssetServices._();
  static final AssetServices instance = AssetServices._();

  /// Get list of unused assets from
  /// lib folder and read .dart file code
  Future<List<UnusedAssetModel>> getUnusedAssets() async {
    String currentPath = FileUtils.instance.getCurrentPath;
    final fileUtils = FileUtils();

    /// Read assets path from pubspec.yaml
    List<String> assetsPath = await fileUtils.getPubspecAsset();
    if (assetsPath.isEmpty) return [];

    /// Remove duplicate assets from [assetsPath]
    assetsPath = assetsPath.toSet().toList();

    /// Get config from assets_cleaner.yaml
    fileUtils.getConfig();
    if (fileUtils.config == null) return [];

    /// Load all assets from pubspec.yaml
    /// and store in [assets]
    List<String> assets = [];
    for (var path in assetsPath) {
      final files = await fileUtils.loadAssets(path);
      for (var file in files) {
        assets.add(file.path.replaceAll(currentPath, ""));
      }
    }

    /// Get exclude file and extensions
    final excludeFile = fileUtils.getExcludeFile();
    final excludeExtension = fileUtils.getExcludeExtension();

    /// Remove exclude extension and file from assets
    assets = _removeExcludedExt(excludeExtension, assets);
    assets = _removeExcludedFile(excludeFile, assets);

    List<UnusedAssetModel> unusedAssets = [];
    if (assets.isEmpty) return [];

    print("-----------------------------");
    print("Scanning ${assets.length} assets file");
    for (var asset in assets) {
      final fileName = asset.split("/").last;
      if (await CodeUtils.instance.containsAsset(fileName) == false) {
        unusedAssets.add(UnusedAssetModel(fileName: fileName, filePath: asset));
      }
    }
    return unusedAssets;
  }

  /// Remove exclude extension from assets
  List<String> _removeExcludedExt(
    List<String> excludedExtensions,
    List<String> value,
  ) {
    for (var ext in excludedExtensions) {
      value.removeWhere((item) => item.contains(".$ext"));
    }
    return value;
  }

  /// Remove exclude file from assets
  List<String> _removeExcludedFile(
    List<String> excludedFiles,
    List<String> value,
  ) {
    for (var file in excludedFiles) {
      value.removeWhere((item) => item == file);
    }
    return value;
  }
}
