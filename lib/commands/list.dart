import 'package:args/command_runner.dart';

import '../application.dart';

class ListCommand extends Command {
  final String name = 'list';
  final String description = 'Show a list of available homework.';
  final Application app;

  ListCommand(this.app);

  void run() async {
    await app.list();
  }
}
