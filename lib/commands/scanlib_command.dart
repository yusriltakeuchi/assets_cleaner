import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:assets_cleaner/utils/msg_utils.dart';
import 'package:yaml/yaml.dart';

class ScanLibCommand extends Command {
  @override
  String get description => "Scan and remove unused library in pubspec.yaml";

  @override
  String get name => "scanlib";

  ScanLibCommand() {
    // Add option --flag or -f
    argParser.addFlag('fast',
        abbr: 'f', negatable: false, help: 'Run the scan in fast mode.');
  }

  @override
  void run() async {
    bool fastMode = argResults?['fast'] ?? false;

    // Memuat file pubspec.yaml
    var pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      MsgUtils.showError("pubspec.yaml file not found in the project.");
      return;
    }

    var pubspecContent = pubspecFile.readAsStringSync();
    var yamlMap = loadYaml(pubspecContent);

    // Memuat dependencies dari pubspec.yaml
    var dependencies = yamlMap['dependencies']?.keys.toList() ?? [];
    if (dependencies.isEmpty) {
      MsgUtils.showError("No dependencies found in pubspec.yaml.");
      return;
    }

    print("---------------------------------------");
    String projectName = yamlMap['name'];
    print("   SCANNING PROJECT $projectName");
    print("---------------------------------------");

    // Scan dependencies yang digunakan di project
    var unusedDependencies = <String>[];
    MsgUtils.showInfo("Scanning unused dependencies...");

    for (var dependency in dependencies) {
      var result = await scanDependency(dependency);
      if (!result) {
        unusedDependencies.add(dependency);
      }
    }

    // Menampilkan hasil scan
    if (unusedDependencies.isEmpty) {
      MsgUtils.showSuccess("All dependencies are in use.");
      return;
    } else {
      MsgUtils.showInfo("Unused dependencies found...");
      print("---------------------------------------");
      unusedDependencies.asMap().forEach((i, dep) {
        MsgUtils.showList("${i + 1}. $dep");
      });
      print("---------------------------------------");

      if (fastMode) {
        removeDependencies(unusedDependencies);
      } else {
        // Removing options
        await showOptions(unusedDependencies);
      }
    }
  }

  Future<bool> scanDependency(String dependency) async {
    // Melakukan pencarian terhadap setiap file di folder lib/
    var libDir = Directory('./lib');
    if (!libDir.existsSync()) {
      MsgUtils.showError("lib directory not found.");
      return false;
    }

    var files = libDir.listSync(recursive: true, followLinks: false);
    for (var file in files) {
      if (file is File && file.path.endsWith('.dart')) {
        var content = file.readAsStringSync();
        if (content.contains(dependency)) {
          return true; // Dependency ditemukan di file Dart
        }
      }
    }
    return false; // Dependency tidak ditemukan di project
  }

  Future<void> showOptions(List<String> unusedDependencies) async {
    print('What would you like to do?');
    print('1. Remove all unused dependencies');
    print('2. Remove specific dependencies');
    print('3. Cancel');

    stdout.write("➢ Your choice: ");
    var input = stdin.readLineSync();
    switch (input) {
      case '1':
        removeDependencies(unusedDependencies);
        break;
      case '2':
        await removeSpecificDependencies(unusedDependencies);
        break;
      case '3':
        MsgUtils.showInfo("Operation cancelled.");
        break;
      default:
        MsgUtils.showError("Invalid option. Exiting...");
    }
  }

  void removeDependencies(
    List<String> unusedDependencies, {
    String? selectedName,
  }) {
    MsgUtils.showInfo(
        "Removing ${selectedName != null ? selectedName : 'dependencies'} from pubspec.yaml...");
    var pubspecFile = File('pubspec.yaml');
    var lines = pubspecFile.readAsLinesSync();

    for (var dep in unusedDependencies) {
      lines.removeWhere((line) => line.contains(dep));
    }

    pubspecFile.writeAsStringSync(lines.join('\n'));
    if (selectedName != null) {
      MsgUtils.showSuccess("$selectedName removed from pubspec.yaml");
    } else {
      MsgUtils.showSuccess("All unused dependencies removed");
    }
  }

  Future<void> removeSpecificDependencies(
      List<String> unusedDependencies) async {
    print("");
    MsgUtils.showInfo(
        "Select dependencies to remove (comma-separated numbers):");
    print("---------------------------------------");
    unusedDependencies.asMap().forEach((i, dep) {
      MsgUtils.showList("${i + 1}. $dep");
    });
    print("---------------------------------------");

    stdout.write("➢ Your choice: ");
    var input = stdin.readLineSync();
    var indexes = input
            ?.split(',')
            .map(int.tryParse)
            .where((n) => n != null && n > 0 && n <= unusedDependencies.length)
            .toList() ??
        [];

    if (indexes.isEmpty) {
      MsgUtils.showError("No valid dependencies selected. Exiting...");
      return;
    }

    var selectedDeps = indexes.map((i) => unusedDependencies[i! - 1]).toList();
    removeDependencies(selectedDeps, selectedName: selectedDeps.first);
  }
}
