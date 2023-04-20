import 'package:args/command_runner.dart';
import 'package:assets_cleaner/models/unused_asset_model.dart';
import 'package:assets_cleaner/services/asset_services.dart';
import 'package:assets_cleaner/utils/file_utils.dart';

class CleanCommand extends Command {
  @override
  String get description => "Clean unused assets in lib folder";

  @override
  String get name => "clean";

  @override
  void run() async {
    /// Get list of unused assets from
    /// lib folder and read .dart file code
    List<UnusedAssetModel> unusedAssets =
        await AssetServices.instance.getUnusedAssets();
    if (unusedAssets.isEmpty) {
      print("-----------------------------");
      print("[✅] No unused assets found");
      print("-----------------------------");
      return;
    }

    print("-----------------------------");
    for (var unused in unusedAssets) {
      print("[♻️ ] Removing asset ${unused.filePath}");
      FileUtils.instance.deleteFile(unused.filePath.replaceFirst("/", ""));
    }
    print("-----------------------------");
    print("Successfully delete ${unusedAssets.length} unused assets files");
    print("-----------------------------");
  }
}
