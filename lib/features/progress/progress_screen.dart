import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_service.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_state.dart';
import 'package:webspark_test/features/results/results_screen.dart';

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
                  MazeSolverSolvingState(
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
              ref.listen(
                mazeSolverServiceProvider,
                (previous, next) {
                  if (next is MazeSolverSolvingState &&
                      next.state == SolvingState.success) {
                    context.pushNamed(ResultsScreen.routeName);
                  }
                },
              );

              return switch (ref.watch(mazeSolverServiceProvider)) {
                final MazeSolverSolvingState progress
                    when progress.isComplete =>
                  switch (progress.state) {
                    SolvingState.pathfinding => buildReadyButton(),
                    SolvingState.sendingResult => buildLoadingButton(),
                    SolvingState.success => buildReadyButton(),
                  },
                MazeSolverErrorState() => buildRetryButton(),
                _ => buildDisabledButton(),
              };
            }),
          ],
        ),
      ),
    );
  }

  ElevatedButton buildDisabledButton() {
    return const ElevatedButton(
      onPressed: null,
      child: Text('Send results to server'),
    );
  }

  ElevatedButton buildLoadingButton() {
    return const ElevatedButton(
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
    );
  }

  Widget buildReadyButton() {
    return Consumer(builder: (context, ref, child) {
      return ElevatedButton(
        onPressed: () {
          ref.watch(mazeSolverServiceProvider.notifier).sendResults();
        },
        child: const Text('Send results to server'),
      );
    });
  }

  Widget buildRetryButton() {
    return Consumer(builder: (context, ref, child) {
      return ElevatedButton(
        onPressed: () async {
          final service = ref.watch(mazeSolverServiceProvider.notifier);
          await service.startSolving();
          await service.sendResults();
        },
        child: const Text('Retry'),
      );
    });
  }
}
