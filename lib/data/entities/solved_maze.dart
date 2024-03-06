import 'dart:math';

import 'package:webspark_test/data/entities/maze.dart';

class MazeSolution {
  const MazeSolution({
    required this.path,
    required this.maze,
  });

  final List<Point<int>> path;
  final Maze maze;

  String get pathString => path.fold(
        '',
        (previousValue, p) {
          final pointString = '(${p.x},${p.y})';

          if (previousValue.isNotEmpty) {
            return '$previousValue->$pointString';
          }
          
          return pointString;
        },
      );
}
