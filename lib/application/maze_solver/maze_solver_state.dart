import 'package:webspark_test/data/entities/maze.dart';
import 'package:webspark_test/data/entities/solved_maze.dart';

sealed class MazeSolverState {
  const MazeSolverState();
}

class MazeSolverFetchingState extends MazeSolverState {
  const MazeSolverFetchingState();
}

class MazeSolverSolvingState extends MazeSolverState {
  const MazeSolverSolvingState({
    this.allMazes = const [],
    this.solutions = const [],
    this.state = SolvingState.pathfinding,
  });

  final List<Maze> allMazes;
  final List<MazeSolution> solutions;
  final SolvingState state;

  bool get isComplete => allMazes.length == solutions.length;

  MazeSolverSolvingState copyWith({
    List<Maze>? allMazes,
    List<MazeSolution>? solutions,
    SolvingState? state,
  }) {
    return MazeSolverSolvingState(
      allMazes: allMazes ?? this.allMazes,
      solutions: solutions ?? this.solutions,
      state: state ?? this.state,
    );
  }
}

class MazeSolverErrorState extends MazeSolverState {
  const MazeSolverErrorState(this.message);

  final String message;
}

enum SolvingState {
  pathfinding,
  sendingResult,
  success,
}
