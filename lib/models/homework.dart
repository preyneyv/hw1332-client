import 'dart:io';

import 'package:dio/dio.dart';
import 'package:io/ansi.dart';

import './gist.dart';

class Homework {
  int number;
  List<Gist> gists;
  Dio _client;
  bool _fetched = false;

  Homework(this.number, Map<String, dynamic> data, this._client) {
    gists = List();
    for (var entry in data.entries) {
      var gistAuthor = entry.key;
      for (var gistId in entry.value)
        gists.add(Gist(gistAuthor, gistId, _client));
    }
  }

  void fetch() async {
    if (_fetched) {
      return;
    }

    await Future.wait(gists.map((gist) => gist.fetch()));

    _fetched = true;
    return;
  }

  void list({bool expand: false}) async {
    await fetch();
    print(this);
    for (final gist in gists) {
      print('  ' + (expand ? gist.toDetailString() : gist.toString()));
    }
  }

  void downloadTo(String destination, {bool overwrite: false}) async {
    await fetch();
    bool skipped = (await Future.wait(
            gists.map((g) => g.downloadTo(destination, overwrite: overwrite))))
        .any((r) => !r);
    if (skipped) {
      print(yellow.wrap('Some files were skipped since they already exist. Run '
          'the command again with --overwrite to replace the existing files!'));
    }
  }

  @override
  String toString() {
    return "${number.toString().padLeft(2, '0')} " +
        styleDim
            .wrap("with ${gists.length} Gist${gists.length == 1 ? '' : 's'}");
  }
}
