import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_state.dart';

import 'package:webspark_test/data/repositories/base_url_repository.dart';
import 'package:webspark_test/data/repositories/maze_repository.dart';
import 'package:webspark_test/data/repositories/pathfinder_repository.dart';

class MazeSolverService extends Notifier<MazeSolverState?> {
  @override
  MazeSolverState? build() {
    final baseUrl = ref.watch(baseUrlRepositoryProvider);

    if (baseUrl == null) {
      return null;
    }

    _startSolving(baseUrl);

    return const FetchingMazesState();
  }

  void _startSolving(String baseUrl) async {
    final mazes = await ref.watch(mazeRepositoryProvider).fetchMazes(baseUrl);

    state = MazeSolverProgressState(allMazes: mazes);

    final pathfinder = ref.read(pathfinderRepositoryProvider);

    for (final maze in mazes) {
      final solution = await pathfinder.solveMaze(maze);

      if (state case final MazeSolverProgressState state) {
        this.state = state.copyWith(solutions: [...state.solutions, solution]);
      }
    }
  }
}

final mazeSolverServiceProvider =
    NotifierProvider<MazeSolverService, MazeSolverState?>(
  MazeSolverService.new,
);
