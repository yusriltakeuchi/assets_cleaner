import 'package:args/command_runner.dart';
import 'package:assets_cleaner/models/unused_asset_model.dart';
import 'package:assets_cleaner/services/asset_services.dart';

class UnusedCommand extends Command {
  @override
  String get description =>
      'Scanning unused assets in lib folder and display it';

  @override
  String get name => 'unused';

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
      print("[⚠️ ] ${unused.filePath}");
    }
    print("-----------------------------");
    print("Found ${unusedAssets.length} unused assets files");
    print("-----------------------------");
  }
}
