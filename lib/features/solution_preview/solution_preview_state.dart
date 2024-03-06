import 'dart:math';

import 'package:webspark_test/data/entities/maze.dart';

class SolutionPreviewState {
  SolutionPreviewState({
    required this.pathPoints,
    required this.pathString,
    required this.maze,
  });

  final String pathString;
  final Set<Point<int>> pathPoints;
  final Maze maze;
}
