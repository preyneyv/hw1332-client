import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';

import '../application.dart';

class ViewCommand extends Command {
  final String name = 'view';
  final String description = 'See the tests available for a specific homework.';
  final Application app;

  ViewCommand(this.app) {}

  void run() async {
    if (argResults.rest.length != 1) {
      print(red.wrap('Please enter exactly ONE homework number to view!'));
      exit(1);
    }
    var number;
    try {
      number = int.parse(argResults.rest.first);
    } on FormatException {
      print(red.wrap('Please enter a valid integer!'));
      exit(1);
    }
    await app.view(number);
  }
}
