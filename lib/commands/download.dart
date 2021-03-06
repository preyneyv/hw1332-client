import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';

import '../application.dart';

class DownloadCommand extends Command {
  final String name = 'download';
  final String description = 'Download the tests available for a homework.';
  final Application app;

  DownloadCommand(this.app) {
    argParser
      ..addOption('destination',
          abbr: 'd',
          help: 'The destination folder to download tests into.',
          defaultsTo: '.')
      ..addFlag('overwrite',
          abbr: 'o', help: 'Overwrite existing files.', defaultsTo: false);
  }

  void run() async {
    if (argResults.rest.length != 1) {
      print(red.wrap('Please enter exactly ONE homework number to download!'));
      exit(1);
    }
    var number;
    try {
      number = int.parse(argResults.rest.first);
    } on FormatException {
      print(red.wrap('Please enter a valid integer!'));
      exit(1);
    }
    await app.download(number,
        path: argResults['destination'], overwrite: argResults['overwrite']);
  }
}
