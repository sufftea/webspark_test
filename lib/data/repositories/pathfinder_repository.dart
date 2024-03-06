import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/data/entities/maze.dart';
import 'package:webspark_test/data/entities/solved_maze.dart';

class PathfinderRepository {
  Future<MazeSolution> solveMaze(Maze maze) async {
    // TODO: implement pathfinding

    await Future.delayed(const Duration(seconds: 1));

    return MazeSolution(
      path: [
        const Point(0, 0),
      ],
      maze: maze,
    );
  }
}

final pathfinderRepositoryProvider = Provider((ref) => PathfinderRepository());
