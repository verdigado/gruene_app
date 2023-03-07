class PermissionException implements Exception {
  String cause;
  PermissionException(this.cause);
}
