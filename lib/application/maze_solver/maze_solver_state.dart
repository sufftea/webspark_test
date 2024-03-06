import 'package:webspark_test/data/entities/maze.dart';
import 'package:webspark_test/data/entities/solved_maze.dart';

sealed class MazeSolverState {
  const MazeSolverState();
}

class MazeSolverFetchingState extends MazeSolverState {
  const MazeSolverFetchingState();
}

class MazeSolverProgressState extends MazeSolverState {
  const MazeSolverProgressState({
    this.allMazes = const [],
    this.solutions = const [],
  });

  final List<Maze> allMazes;
  final List<MazeSolution> solutions;

  bool get isComplete => allMazes.length == solutions.length;

  MazeSolverProgressState copyWith({
    List<Maze>? allMazes,
    List<MazeSolution>? solutions,
  }) {
    return MazeSolverProgressState(
      allMazes: allMazes ?? this.allMazes,
      solutions: solutions ?? this.solutions,
    );
  }
}

class MazeSolverSendingState extends MazeSolverState {
  MazeSolverSendingState(this.progressState);

  final MazeSolverProgressState progressState;
}

class MazeSolverSuccessState extends MazeSolverState {
  MazeSolverSuccessState(this.progressState);

  final MazeSolverProgressState progressState;
}

class MazeSolverErrorState extends MazeSolverState {
  const MazeSolverErrorState(this.message);

  final String message;
}
