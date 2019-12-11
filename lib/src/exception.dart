class CustomException implements Exception {
  CustomException(this.cause);
  String cause;
}
