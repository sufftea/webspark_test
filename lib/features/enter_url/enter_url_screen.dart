import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webspark_test/features/enter_url/url_test_controller.dart';
import 'package:webspark_test/features/enter_url/url_test_state.dart';
import 'package:webspark_test/features/progress/progress_screen.dart';

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
      urlTestControllerProvider,
      (previous, next) {
        switch (next) {
          case UrlTestSuccess():
            context.goNamed(ProgressScreen.routeName);
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
              return switch (ref.watch(urlTestControllerProvider)) {
                final UrlTestError e => Text(e.message),
                _ => const SizedBox.shrink(),
              };
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(urlTestControllerProvider.notifier)
                    .testUrl(textController.text);
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
