import 'package:go_router/go_router.dart';
import 'package:webspark_test/features/enter_link/enter_url_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: EnterLinkScreen.routeName,
      builder: (context, state) => const EnterLinkScreen(),
    ),
  ],
);
