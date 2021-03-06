import 'dart:io';

import 'package:dio/dio.dart';
import 'package:io/ansi.dart';

import 'file.dart';

class Gist {
  final String author;
  final String id;
  final Dio _client;
  bool _fetched = false;

  List<File> files;

  Gist(this.author, this.id, this._client);

  String get apiUrl => "https://github.gatech.edu/api/v3/gists/$id";
  String get htmlUrl => "https://github.gatech.edu/gist/$id";

  Future<Gist> fetch() async {
    if (_fetched) {
      return this;
    }

    final res = await _client.get(apiUrl);
    files = [
      for (final data in Map<String, dynamic>.from(res.data['files']).values)
        File.fromJson(_client, data)
    ];

    _fetched = true;
    return this;
  }

  Future<bool> downloadTo(String destination, {bool overwrite: false}) async {
    return (await Future.wait(
            files.map((f) => f.downloadTo(destination, overwrite: overwrite))))
        .every((x) => x);
  }

  String toDetailString() {
    return "${toString()}\n    ${styleDim.wrap('› ' + htmlUrl)}";
  }

  @override
  String toString() {
    final filesString = files.map((f) => f.name).join(', ');
    return "$filesString ${blue.wrap("(by $author)")}";
  }
}
