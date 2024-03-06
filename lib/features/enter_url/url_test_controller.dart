import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/data/repositories/base_url_repository.dart';
import 'package:webspark_test/features/enter_url/url_test_state.dart';

class UrlTestController extends Notifier<UrlTestState?> {
  @override
  UrlTestState? build() {
    return null;
  }

  void testUrl(String url) async {
    try {
      ref.watch(baseUrlRepositoryProvider.notifier).setBaseUrl(url);
      state = UrlTestSuccess();
    } on InvalidUrlException catch (_) {
      state = UrlTestError('Invalid URL. Please try again.');
    }
  }
}

final urlTestControllerProvider =
    NotifierProvider<UrlTestController, UrlTestState?>(
  () => UrlTestController(),
);
