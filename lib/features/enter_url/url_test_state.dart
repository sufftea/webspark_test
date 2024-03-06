sealed class UrlTestState {
  const UrlTestState();
}

class UrlTestSuccess extends UrlTestState {}

class UrlTestError extends UrlTestState {
  UrlTestError(this.message);
  final String message;
}
