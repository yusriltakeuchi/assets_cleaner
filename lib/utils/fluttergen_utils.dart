import 'dart:io';

import 'package:assets_cleaner/models/gen_model.dart';
import 'package:assets_cleaner/utils/msg_utils.dart';

class FlutterGenUtils {
  static final FlutterGenUtils _instance = FlutterGenUtils._internal();

  // Private constructor
  FlutterGenUtils._internal();

  // Public getter for accessing the instance
  static FlutterGenUtils get instance => _instance;

  Future<List<GenModel>> extractAssetVariables(String genPath) async {
    final Directory dir = Directory(genPath);
    final List<GenModel> assetModels = [];
    Map<String, String> assetCategories = {};
    Map<String, String> pathToCategory = {};

    if (!dir.existsSync()) {
      MsgUtils.showError('Directory not found: $genPath');
      return [];
    }

    final List<FileSystemEntity> files = dir.listSync(recursive: true);
    if (files.isEmpty) {
      MsgUtils.showError('No files found in $genPath');
      return [];
    }

    for (var file in files) {
      if (file is File && file.path.endsWith('.gen.dart')) {
        final String content = await file.readAsString();
        MsgUtils.showInfo('Processing file: ${file.path}');

        /// Extract Assets class structure
        final RegExp assetsClassRegex = RegExp(r'class Assets {[\s\S]*?}');
        final Match? assetsClassMatch = assetsClassRegex.firstMatch(content);

        if (assetsClassMatch != null) {
          final String assetsClassContent = assetsClassMatch.group(0) ?? '';
          final RegExp categoryRegex = RegExp(
            r'static const \$Assets(\w+)Gen (\w+) = \$Assets\1Gen$$$$;',
          );
          final Iterable<RegExpMatch> categoryMatches =
              categoryRegex.allMatches(assetsClassContent);

          for (var match in categoryMatches) {
            final String categoryName = match.group(2) ?? '';
            final String className = match.group(1) ?? '';
            assetCategories[className.toLowerCase()] = categoryName;
          }
        }

        // Find asset classes and their contents
        final RegExp classRegex = RegExp(
          r'class\s+\$Assets(\w+)Gen\s*{([\s\S]*?)}',
        );
        final Iterable<RegExpMatch> classMatches =
            classRegex.allMatches(content);

        for (var classMatch in classMatches) {
          final String className = classMatch.group(1)?.toLowerCase() ?? '';
          final String classContent = classMatch.group(2) ?? '';
          final String category = assetCategories[className] ?? className;

          final RegExp assetRegex = RegExp(
            r"AssetGenImage get (\w+)\s*=>\s*const AssetGenImage\('(assets/[^\']+)'\);",
          );
          final Iterable<RegExpMatch> assetMatches =
              assetRegex.allMatches(classContent);

          if (assetMatches.isEmpty) {
            MsgUtils.showError(
              'No assets found in ${file.path} for category $category',
            );
          } else {
            for (var assetMatch in assetMatches) {
              final String variableName = assetMatch.group(1) ?? '';
              final String assetPath = assetMatch.group(2) ?? '';

              if (assetPath.isNotEmpty) {
                /// Extract the subfolder name from the asset path
                final subfolderName = assetPath.split('/')[1];
                pathToCategory[subfolderName] = category;

                assetModels.add(GenModel(
                  variable: 'Assets.$category.$variableName',
                  path: assetPath,
                ));
              } else {
                MsgUtils.showError(
                  'Could not find path for asset: $variableName',
                );
              }
            }
          }
        }
      }
    }

    /// Create a new list with corrected categories
    final List<GenModel> correctedAssetModels = assetModels.map((model) {
      final subfolderName = model.path.split('/')[1];
      final correctCategory = pathToCategory[subfolderName];
      if (correctCategory != null &&
          correctCategory != model.variable.split('.')[1]) {
        final newVariable =
            'Assets.$correctCategory.${model.variable.split('.').last}';
        MsgUtils.showInfo(
            'Updated asset category: $newVariable = ${model.path}');
        return GenModel(variable: newVariable, path: model.path);
      }
      return model;
    }).toList();

    return correctedAssetModels;
  }
}
