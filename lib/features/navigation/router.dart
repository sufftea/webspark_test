import 'package:go_router/go_router.dart';
import 'package:webspark_test/features/enter_url/enter_url_screen.dart';
import 'package:webspark_test/features/progress/progress_screen.dart';
import 'package:webspark_test/features/results/results_screen.dart';
import 'package:webspark_test/features/solution_preview/solution_preview_screen.dart';

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
          routes: [
            GoRoute(
              path: 'results',
              name: ResultsScreen.routeName,
              builder: (context, state) => const ResultsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  name: SolutionPreviewScreen.routeName,
                  builder: (context, state) {
                    return SolutionPreviewScreen(
                      solutionId: state.pathParameters['id']!,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
