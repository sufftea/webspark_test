import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_service.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_state.dart';
import 'package:webspark_test/data/repositories/base_url_repository.dart';
import 'package:webspark_test/data/repositories/maze_repository.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const routeName = 'process';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solving'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer(
              builder: (context, ref, child) {
                return switch (ref.watch(mazeSolverServiceProvider)) {
                  MazeSolverFetchingState() => const Text('Fetching mazes'),
                  MazeSolverProgressState(
                    solutions: final solutions,
                    allMazes: final allMases,
                  ) =>
                    Text(
                      'Solving mazes: ${solutions.length} / ${allMases.length}',
                    ),
                  final MazeSolverErrorState state => Text(state.message),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
            const Spacer(),
            Consumer(builder: (context, ref, child) {
              final baseUrl = ref.watch(baseUrlRepositoryProvider);

              ref.listen(
                mazeSolverServiceProvider,
                (previous, next) {
                  if (previous is! MazeSolverSuccessState &&
                      next is MazeSolverSuccessState) {
                    debugPrint('navigating to results screen');
                    // context.pushNamed(name);
                  }
                },
              );

              return switch (ref.watch(mazeSolverServiceProvider)) {
                final MazeSolverProgressState progress
                    when progress.isComplete =>
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .watch(mazeSolverServiceProvider.notifier)
                          .sendResults();
                    },
                    child: const Text('Send results to server'),
                  ),
                MazeSolverSendingState() => const ElevatedButton(
                    onPressed: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 24,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Send results to server'),
                      ],
                    ),
                  ),
                MazeSolverErrorState() => const ElevatedButton(
                    onPressed: null,
                    child: Text('Send results to server'),
                  ),
                _ => const SizedBox.shrink(),
              };
            }),
          ],
        ),
      ),
    );
  }
}
