import 'package:args/command_runner.dart';

class AboutCommand extends Command {
  final String name = 'about';
  final String description = 'Why does this exist?';

  void run() async {
    print('''
\n                   A B O U T   T H I S   P R O G R A M

This program was written on March 6th, 2021 when one Pranav felt excessively
lazy. So lazy, in fact, that he deemed that it was too much effort to open
Piazza and download the student-written tests himself. So he chose to do the
only logical option in this scenario: spend 12 hours writing a Piazza scraper
in Python and a distributable client in Dart.

The Piazza scraper frequently pulls all followups to the "Shared JUnits" Piazza
posts and extracts all GitHub Gist links from them. After consolidating them
into a more machine-friendly JSON structure, it pushes them to a Gist. This
client, when run, will pull the latest version of that Gist and use it as an
index, a table of contents. Depending on what you, the user, choose to do, the
client will download the files in the Gist to your local filesystem.

Built by @preyneyv.\n''');
  }
}
