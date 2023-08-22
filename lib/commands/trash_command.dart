import 'package:args/command_runner.dart';
import 'package:assets_cleaner/models/unused_asset_model.dart';
import 'package:assets_cleaner/services/asset_services.dart';
import 'package:assets_cleaner/utils/file_utils.dart';

class TrashCommand extends Command {
  @override
  String get description => "Move unused assets into trash folder";

  @override
  String get name => "trash";

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
      print("[♻️ ] Moving asset ${unused.filePath}");
      FileUtils.instance.moveToTrash(unused.filePath);
    }
    print("-----------------------------");
    print(
        "Successfully moving ${unusedAssets.length} unused assets to trash folder");
    print("-----------------------------");
  }
}
