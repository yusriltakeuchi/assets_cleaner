import 'package:assets_cleaner/models/gen_model.dart';
import 'package:assets_cleaner/models/unused_asset_model.dart';
import 'package:assets_cleaner/utils/code_utils.dart';
import 'package:assets_cleaner/utils/file_utils.dart';
import 'package:assets_cleaner/utils/fluttergen_utils.dart';
import 'package:assets_cleaner/utils/msg_utils.dart';
import 'package:glob/glob.dart';

class AssetServices {
  factory AssetServices() => instance;

  AssetServices._();

  static final AssetServices instance = AssetServices._();

  /// Get list of unused assets from
  Future<List<UnusedAssetModel>> getUnusedAssets() async {
    String currentPath = FileUtils.instance.getCurrentPath;
    final fileUtils = FileUtils();

    /// Read assets path from pubspec.yaml
    List<String> assetsPath = await fileUtils.getPubspecAsset();

    /// Remove if path not start with assets
    assetsPath.removeWhere((element) => !element.startsWith("assets"));
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
        /// Remove '/' on the first character
        String assetsPath = file.path.replaceAll(currentPath, "");
        if (assetsPath.startsWith("/")) {
          assetsPath = assetsPath.substring(1);
          assets.add(assetsPath);
        } else {
          assets.add(assetsPath);
        }
      }
    }

    /// Get exclude file and extensions
    final excludeFile = fileUtils.getExcludeFile();
    final excludeExtension = fileUtils.getExcludeExtension();

    /// Remove exclude extension and file from assets
    assets = _removeExcludedExt(excludeExtension, assets);
    assets = _removeExcludedFile(excludeFile, assets);

    List<UnusedAssetModel> unusedAssets = [];

    if (assets.isNotEmpty) {
      print("-----------------------------");
      print("Scanning ${assets.length} assets file");
      for (var asset in assets) {
        final fileName = asset.split("/").last;
        if (await CodeUtils.instance.containsAsset(fileName) == false) {
          unusedAssets.add(
            UnusedAssetModel(fileName: fileName, filePath: asset),
          );
        }
      }
    }

    /// Read fluttergen path from pubspec.yaml
    String genPath = await fileUtils.getFlutterGenPath();

    /// Get list of assets from flutter_gen
    List<GenModel> genAssets =
        await FlutterGenUtils.instance.extractAssetVariables(genPath);
    if (genAssets.isNotEmpty) {
      print("-----------------------------");
      print("Scanning ${genAssets.length} flutter_gen assets variables");
      MsgUtils.showInfo("Find unused assets from flutter_gen");
      for (var genAsset in genAssets) {
        if (await CodeUtils.instance.containsFlutterGenAssets(genAsset) ==
            false) {
          MsgUtils.showList("${genAsset.variable}");
          unusedAssets.add(UnusedAssetModel(
            fileName: genAsset.path.split("/").last,
            filePath: genAsset.path,
          ));
        }
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
    for (var pattern in excludedFiles) {
      final glob = Glob(pattern);
      value.removeWhere((item) => glob.matches(item) || item == pattern);
    }
    return value;
  }
}
