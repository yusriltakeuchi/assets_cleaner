import 'package:args/command_runner.dart';
import 'package:assets_cleaner/services/config_services.dart';

class InitCommand extends Command {
  @override
  String get description => 'Creating assets_cleaner.yaml file to your project';

  @override
  String get name => 'init';

  @override
  void run() async {
    /// Creating assets_cleaner.yaml file
    final result = await ConfigServices.instance.create();
    if (result) {
      print("---------------------------------------");
      print("[✅] Successfully create assets_cleaner.yaml file");
      print("---------------------------------------");
    } else {
      print("---------------------------------------");
      print("[🚫] Failed to create assets_cleaner.yaml file");
      print("---------------------------------------");
    }
  }
}
