import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class UrlTestState {
  const UrlTestState();
}

class UrlTestAwaiting extends UrlTestState {}

class UrlTestSuccess extends UrlTestState {
  const UrlTestSuccess(this.url);
  final Uri url;
}

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
    if (Uri.tryParse(url) case final url? when url.host.isNotEmpty) {
      state = UrlTestSuccess(url);
    } else {
      state = UrlTestError('Invalid URL. Please try again');
    }
  }
}

final urlTestProvider = NotifierProvider<UrlTestNotifier, UrlTestState>(
  () => UrlTestNotifier(),
);
