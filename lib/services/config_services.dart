import 'dart:io';

class ConfigServices {
  factory ConfigServices() => instance;
  ConfigServices._();
  static final ConfigServices instance = ConfigServices._();

  /// The function `create` downloads a YAML file from a given URL and saves it to a local file.
  ///
  /// Returns:
  ///
  /// The function `create()` returns a `Future<bool>`.
  Future<bool> create() async {
    try {
      String templateUrl =
          "https://raw.githubusercontent.com/yusriltakeuchi/assets_cleaner/master/template/assets_cleaner.yaml";

      /// Downloading from the url and save to [path]
      final request = await HttpClient().getUrl(Uri.parse(templateUrl));
      final response = await request.close();
      response.pipe(File('assets_cleaner.yaml').openWrite());
      return true;
    } catch (e) {
      return false;
    }
  }
}
