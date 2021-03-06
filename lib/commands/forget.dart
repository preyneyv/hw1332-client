import 'package:args/command_runner.dart';
import '../application.dart';

class ForgetCommand extends Command {
  final String name = 'forget';
  final String description = 'Delete saved credentials.';
  final Application app;

  ForgetCommand(this.app);

  void run() async {
    print('You will be missed...');
    await app.forget();
    print('Farewell.');
  }
}
