import 'package:dart_app_data/dart_app_data.dart';
import 'package:args/command_runner.dart';

import 'application.dart';
import 'commands/about.dart';
import 'commands/download.dart';
import 'commands/forget.dart';
import 'commands/list.dart';
import 'commands/view.dart';

void main(List<String> args) async {
  final appData = AppData.findOrCreate('.hw1332_client');
  final app = Application(appData);

  CommandRunner('hw1332',
      "The epitome of laziness. An automated way to download CS 1332 Student Tests.\nBuilt by @preyneyv in March 2021.")
    ..addCommand(AboutCommand())
    ..addCommand(DownloadCommand(app))
    ..addCommand(ForgetCommand(app))
    ..addCommand(ListCommand(app))
    ..addCommand(ViewCommand(app))
    ..run(args);
}
