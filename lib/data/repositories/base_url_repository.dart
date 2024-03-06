import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseUrlRepository extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void setBaseUrl(String url) {
    if (Uri.tryParse(url)?.host.isNotEmpty ?? false) {
      state = url;
    } else {
      throw InvalidUrlException(url);
    }

    state = url;
  }
}

class InvalidUrlException implements Exception {
  InvalidUrlException(this.url);

  final String url;

  @override
  String toString() {
    return 'Invalid URL: $url';
  }
}

final baseUrlRepositoryProvider = NotifierProvider<BaseUrlRepository, String?>(
  () => BaseUrlRepository(),
);
