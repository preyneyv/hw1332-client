import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:io/ansi.dart';

import 'config.dart';
import 'models/homework.dart';

class GistClient {
  Dio _client;

  GistClient() {
    _client = Dio(BaseOptions(responseType: ResponseType.json));
  }

  /// Make an API request to test internet connectivity.
  Future<void> ensureInternet() async {
    await testCredentials();
  }

  Future<bool> testCredentials({GistCredentials credentials}) async {
    try {
      final options = Options();
      if (credentials != null)
        options.headers['authorization'] = credentials.header;

      await _client.get(config.apiRoot, options: options);
      return true;
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        // Request went through but creds are wrong.
        return false;
      } else {
        print(red.wrap("Couldn't reach the Internet! Are you connected?"));
        print(red.wrap(e.message));
        exit(1);
      }
    }
  }

  void setCredentials(GistCredentials credentials) {
    _client.options.headers['authorization'] = credentials.header;
  }

  Future<Map<int, Homework>> getHomework() async {
    var res;
    try {
      res = await _client.get(config.sourceGist);
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        print(red.wrap(
            "Error in fetching homework listing! Perhaps your credentials are incorrect?"));
        print("Server says: " + e.response.data);
        return null;
      } else {
        print(red.wrap("Couldn't reach the Internet! Are you connected?"));
        print(red.wrap(e.message));
        exit(1);
      }
    }

    final data = Map<String, dynamic>.from(json.decode(res.data));

    final homework = {
      for (final k in data.keys)
        int.parse(k): Homework(int.parse(k), data[k], _client)
    };
    return homework;
  }
}

class GistCredentials {
  final String _username;
  final String _password;
  GistCredentials(this._username, this._password);

  factory GistCredentials.fromJson(Map<String, dynamic> data) {
    return GistCredentials(data['username'], data['password']);
  }

  String get header =>
      'Basic ' + base64Encode(utf8.encode('$_username:$_password'));

  Map<String, dynamic> toJson() {
    return {'username': _username, 'password': _password};
  }
}
