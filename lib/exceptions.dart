class NetworkException implements Exception {
  String cause;
  NetworkException(this.cause);
}

class UnknownHomeworkException implements Exception {
  String cause;
  UnknownHomeworkException(this.cause);
}
