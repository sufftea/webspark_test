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

    return const MazeSolverFetchingState();
  }

  Future<void> sendResults() async {
    final baseUrl = ref.watch(baseUrlRepositoryProvider);

    if (baseUrl == null) {
      throw StateError('sendResults called without providing baseURL');
    }

    if (state case final MazeSolverProgressState state when state.isComplete) {
      try {
        this.state = MazeSolverSendingState(state);

        await ref
            .watch(mazeRepositoryProvider(baseUrl))
            .sendResult(state.solutions);

        this.state = MazeSolverSuccessState(state);
      } on MazeRepositoryException catch (e) {
        this.state = MazeSolverErrorState(e.message);
      }
    } else {
      throw StateError('sendResults called before the computation finished');
    }
  }

  void _startSolving(String baseUrl) async {
    final mazes = await ref.watch(mazeRepositoryProvider(baseUrl)).fetchMazes();

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
