import 'package:args/command_runner.dart';
import 'package:assets_cleaner/commands/clean_command.dart';
import 'package:assets_cleaner/commands/init_command.dart';
import 'package:assets_cleaner/commands/unused_command.dart';

void main(List<String> args) {
  /// Initializing commands
  final _ = CommandRunner<void>(
    'assets_cleaner',
    'Clean unused assets in Flutter project',
  )
    ..addCommand(UnusedCommand())
    ..addCommand(CleanCommand())
    ..addCommand(InitCommand())
    ..run(args);
}
