import 'dart:math';

import 'package:webspark_test/data/entities/maze.dart';

class MazeSolution {
  const MazeSolution({
    required this.path,
    required this.maze,
  });

  final List<Point> path;
  final Maze maze;
}
