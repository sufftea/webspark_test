import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_service.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_state.dart';
import 'package:webspark_test/features/solution_preview/solution_preview_state.dart';

final solutionPreviewProvider = Provider.family<SolutionPreviewState?, String>(
  (ref, id) {
    final state = ref.watch(mazeSolverServiceProvider);

    if (state is MazeSolverSolvingState) {
      final solution =
          state.solutions.where((element) => element.maze.id == id).firstOrNull;

      if (solution == null) {
        return null;
      }

      return SolutionPreviewState(
        pathPoints: solution.path.toSet(),
        pathString: solution.pathString,
        maze: solution.maze,
      );
    }

    return null;
  },
);
