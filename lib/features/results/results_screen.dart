import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_service.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_state.dart';
import 'package:webspark_test/data/entities/solved_maze.dart';
import 'package:webspark_test/features/results/solution_entry_widget.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  static const routeName = 'results';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('results'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return switch (ref.watch(mazeSolverServiceProvider)) {
            final MazeSolverSolvingState state => buildList(state.solutions),
            _ => const Text('No results yet'),
          };
        },
      ),
    );
  }

  Widget buildList(List<MazeSolution> solutions) {
    return ListView.builder(
      itemCount: solutions.length,
      itemBuilder: (context, index) {
        return SolutionEntryWidget(solution: solutions[index]);
      },
    );
  }
}
