import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class UrlTestState {}

class UrlTestAwaiting extends UrlTestState {}

class UrlTestSuccess extends UrlTestState {}

class UrlTestError extends UrlTestState {
  UrlTestError(this.message);
  final String message;
}

class UrlTestNotifier extends Notifier<UrlTestState> {
  @override
  UrlTestState build() {
    return UrlTestAwaiting();
  }

  Future<void> testUrl(String url) async {
    if (Uri.tryParse(url)?.host.isNotEmpty ?? false) {
      state = UrlTestSuccess();
    } else {
      state = UrlTestError('Invalid URL. Please try again');
    }
  }
}

final urlTestProvider = NotifierProvider<UrlTestNotifier, UrlTestState>(
  () => UrlTestNotifier(),
);
