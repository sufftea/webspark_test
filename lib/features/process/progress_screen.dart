import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_service.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_state.dart';

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
                  FetchingMazesState() => const Text('Fetching mazes'),
                  MazeSolverProgressState(
                    solutions: final solutions,
                    allMazes: final allMases,
                  ) =>
                    Text(
                      'Solving mazes: ${solutions.length} / ${allMases.length}',
                    ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
            const Spacer(),
            Consumer(builder: (context, ref, child) {
              if (ref.watch(mazeSolverServiceProvider)
                  case final MazeSolverProgressState progress) {
                if (progress.solutions.length == progress.allMazes.length) {
                  return ElevatedButton(
                    onPressed: () {},
                    child: const Text('Send results to server'),
                  );
                }
              }

              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
