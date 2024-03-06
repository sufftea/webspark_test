import 'package:go_router/go_router.dart';
import 'package:webspark_test/features/enter_url/enter_url_screen.dart';
import 'package:webspark_test/features/progress/progress_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: EnterLinkScreen.routeName,
      builder: (context, state) => const EnterLinkScreen(),
      routes: [
        GoRoute(
          path: 'solving',
          name: ProgressScreen.routeName,
          builder: (context, state) => const ProgressScreen(),
        ),
      ],
    ),
  ],
);
