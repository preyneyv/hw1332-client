import 'dart:io' as io;

import 'package:io/ansi.dart';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';

class File {
  String rawUrl;
  String name;
  String content;
  Dio _client;

  File(this.name, this.rawUrl, this._client, {this.content});

  File.fromJson(this._client, Map<String, dynamic> data) {
    this.name = data['filename'];
    this.rawUrl = data['raw_url'];
    if (!data['truncated']) {
      this.content = data['content'];
    }
  }

  Future<String> getContent() async {
    if (content != null) {
      return content;
    }

    content = (await _client.get(rawUrl)).data;
    return content;
  }

  Future<bool> downloadTo(String destination, {bool overwrite: false}) async {
    final f = io.File(p.join(destination, name));
    if (await f.existsSync() && !overwrite) {
      print(styleDim.wrap('${name} exists! Skipping...'));
      return false;
    }

    await f.writeAsString(await getContent());
    print(green.wrap('Wrote ${name}!'));
    return true;
  }
}
