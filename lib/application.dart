import 'dart:convert';
import 'dart:io';

import 'package:dart_app_data/dart_app_data.dart';
import 'package:io/ansi.dart';
import 'package:path/path.dart' as p;
import 'package:prompts/prompts.dart' as prompts;

import 'helpers.dart' as helpers;
import 'gist_client.dart';
import 'models/homework.dart';

class Application {
  GistClient _client;
  Map<int, Homework> homework;
  bool _initialized = false;
  AppData _appData;
  File _credFile;

  Application(this._appData) {
    _client = GistClient();
    _credFile = File(p.join(_appData.path, 'creds.json'));
  }

  void initialize() async {
    if (_initialized) {
      return;
    }

    await _client.ensureInternet();

    // Fetch the credentials, either from storage or by asking the user.
    _client.setCredentials(await _authenticate());

    // Get homework!
    homework = await _client.getHomework();
    if (homework == null) {
      // Couldn't fetch homework, reset credentials.
      await forget();
      exit(1);
    }
    _initialized = true;
  }

  void list() async {
    await initialize();
    final keys = homework.keys.toList()..sort();
    print('Currently available:');
    for (final key in keys.reversed) {
      print('  ' + homework[key].toString());
    }
  }

  void view(int number) async {
    await initialize();
    if (!homework.containsKey(number)) {
      print(red.wrap("HW${number.toString().padLeft(2, '0')} is unknown!"));
      exit(1);
    }
    final hw = homework[number];
    await hw.list(expand: true);
  }

  void download(int number, {String path, bool overwrite}) async {
    await initialize();
    if (!homework.containsKey(number)) {
      print(red.wrap("HW${number.toString().padLeft(2, '0')} is unknown!"));
      list();
      exit(1);
    }
    final hw = homework[number];
    final destination = p.canonicalize(path ?? Directory.current.path);
    await Directory(destination).create(recursive: true);

    print('Downloading and saving student tests...');
    await hw.list();
    await hw.downloadTo(destination, overwrite: overwrite);
  }

  void forget() async {
    if (await _credFile.exists()) {
      await _credFile.delete();
    }
  }

  /// Try to get credentials from storage or ask the user for them.
  Future<GistCredentials> _authenticate(
      {bool tfa: false, String oldUsername: null}) async {
    GistCredentials creds;
    if (await _credFile.exists()) {
      try {
        // Load the credentials from the JSON file.
        creds = GistCredentials.fromJson(
            json.decode(await _credFile.readAsString()));
      } on Exception {
        // Error with the stored file. Wipe and try again.
        await forget();
        return _authenticate();
      }
    } else {
      // We don't have stored credentials.
      String username = oldUsername;
      if (username == null)
        username = prompts.get('GATech GitHub Username');
      else
        print(styleDim.wrap("Using `$username` as the username..."));
      String password = prompts
          .get('GATech GitHub ${tfa ? 'Token' : 'Password'}', conceal: true);
      creds = GistCredentials(username, password);
      switch (await _client.testCredentials(credentials: creds)) {
        case GistCredentialsTestResult.FAILURE:
          print(red.wrap("Hmm, that doesn't seem right! Please try again."));
          return _authenticate(tfa: tfa, oldUsername: oldUsername);
        case GistCredentialsTestResult.TFA:
          print(yellow.wrap(
              "It appears you have 2FA enabled! Good on you! But that complicates things..."));
          print(yellow.wrap(
              "Go to ${styleUnderlined.wrap('https://github.gatech.edu/settings/tokens/new')} and create a new token."));
          print(yellow.wrap(
              "You don't need to tick any boxes. Just give it a nickname and copy the token."));
          print(yellow.wrap("Once you have that, paste it back here."));
          return _authenticate(tfa: true, oldUsername: username);
        default:
      }
      print(green.wrap('That worked!'));
      bool remember =
          prompts.getBool('Remember these credentials?', defaultsTo: true);
      if (remember) await _credFile.writeAsString(json.encode(creds.toJson()));
    }
    return creds;
  }
}
