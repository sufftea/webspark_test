import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/features/enter_link/url_test_provider.dart';

class EnterLinkScreen extends ConsumerStatefulWidget {
  const EnterLinkScreen({super.key});

  static const routeName = "home";

  @override
  ConsumerState<EnterLinkScreen> createState() => _EnterLinkScreenState();
}

class _EnterLinkScreenState extends ConsumerState<EnterLinkScreen> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(
      urlTestProvider,
      (previous, next) {
        switch (next) {
          case UrlTestSuccess():
            debugPrint('success');
          // conetxt.goNamed(name)
          default:
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter the api entrypoint'),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
            ),
            const SizedBox(height: 16),
            Consumer(builder: (context, ref, child) {
              return switch (ref.watch(urlTestProvider)) {
                final UrlTestError e => Text(e.message),
                _ => const SizedBox.shrink(),
              };
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(urlTestProvider.notifier).testUrl(textController.text);
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
