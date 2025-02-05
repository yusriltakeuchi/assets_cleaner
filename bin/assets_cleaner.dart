import 'package:args/command_runner.dart';
import 'package:assets_cleaner/commands/command.dart';

void main(List<String> args) {
  /// Initializing commands
  final _ = CommandRunner<void>(
    'assets_cleaner',
    'Clean unused assets in Flutter project',
  )
    ..addCommand(UnusedCommand())
    ..addCommand(CleanCommand())
    ..addCommand(InitCommand())
    ..addCommand(TrashCommand())
    ..addCommand(ScanLibCommand())
    ..run(args);
}
