import 'package:webspark_test/data/entities/maze.dart';
import 'package:webspark_test/data/entities/solved_maze.dart';

sealed class MazeSolverState {
  const MazeSolverState();
}

class FetchingMazesState extends MazeSolverState {
  const FetchingMazesState();
}

class MazeSolverProgressState extends MazeSolverState {
  const MazeSolverProgressState({
    this.allMazes = const [],
    this.solutions = const [],
  });

  final List<Maze> allMazes;
  final List<MazeSolution> solutions;

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
