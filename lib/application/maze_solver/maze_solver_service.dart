import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_state.dart';

import 'package:webspark_test/data/repositories/base_url_repository.dart';
import 'package:webspark_test/data/repositories/maze_repository.dart';
import 'package:webspark_test/data/repositories/pathfinder_repository.dart';

class MazeSolverService extends Notifier<MazeSolverState?> {
  @override
  MazeSolverState? build() {
    return const MazeSolverFetchingState();
  }

  Future<void> sendResults() async {
    final baseUrl = ref.watch(baseUrlRepositoryProvider);

    if (baseUrl == null) {
      throw StateError('sendResults called without providing baseURL');
    }

    final state = this.state;
    if (state is MazeSolverSolvingState && state.isComplete) {
      try {
        this.state = state.copyWith(state: SolvingState.sendingResult);

        await ref
            .watch(mazeRepositoryProvider(baseUrl))
            .sendResult(state.solutions);

        this.state = state.copyWith(state: SolvingState.success);
      } on MazeRepositoryException catch (e) {
        this.state = MazeSolverErrorState(e.message);
      }
    } else {
      throw StateError('sendResults called before the computation finished');
    }
  }

  void startSolving() async {
    final baseUrl = ref.watch(baseUrlRepositoryProvider);

    if (baseUrl == null) {
      return;
    }

    final mazes = await ref.watch(mazeRepositoryProvider(baseUrl)).fetchMazes();

    state = MazeSolverSolvingState(allMazes: mazes);

    final pathfinder = ref.read(pathfinderRepositoryProvider);

    for (final maze in mazes) {
      final solution = await pathfinder.solveMaze(maze);

      if (state case final MazeSolverSolvingState state) {
        this.state = state.copyWith(solutions: [...state.solutions, solution]);
      }
    }
  }
}

final mazeSolverServiceProvider =
    NotifierProvider<MazeSolverService, MazeSolverState?>(
  MazeSolverService.new,
);
