class BlocError extends Error {
  final bool expose;
  final String message;
  Exception? cause;
  BlocError({
    required this.message,
    this.expose = false,
    this.cause,
  });

  @override
  String toString() => 'BlocError message: $message, cause: $cause)';
}
