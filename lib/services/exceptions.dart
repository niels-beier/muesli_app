class NoServerConnectionException implements Exception {
  String cause;
  NoServerConnectionException(this.cause);
}