import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/data/entities/maze.dart';
import 'package:webspark_test/data/entities/solved_maze.dart';

class PathfinderRepository {
  Future<MazeSolution> solveMaze(Maze maze) async {
    return compute(
      (maze) {
        final path = AStar(maze).findPath();
        return MazeSolution(path: path, maze: maze);
      },
      maze,
    );
  }
}

final pathfinderRepositoryProvider = Provider((ref) => PathfinderRepository());

class AStar {
  const AStar(this.maze);

  final Maze maze;

  int heuristic(Point<int> a, Point<int> b) {
    final xDist = (a.x - b.x).abs();
    final yDist = (a.y - b.y).abs();

    return min(xDist, yDist) * 4 + max(xDist, yDist) * 10;
  }

  Iterable<Point<int>> neighbors(Point<int> p) {
    return [
      p + const Point(0, 1),
      p + const Point(0, -1),
      p + const Point(1, 0),
      p + const Point(1, 1),
      p + const Point(1, -1),
      p + const Point(-1, 0),
      p + const Point(-1, 1),
      p + const Point(-1, -1),
    ].where(
      (point) =>
          point.x >= 0 &&
          point.y >= 0 &&
          point.x < maze.field.first.length &&
          point.y < maze.field.length,
    );
  }

  List<Point<int>> findPath() {
    final startNode = PathNode(
      position: maze.start,
      fCost: heuristic(maze.start, maze.end),
    );

    final closed = <int, PathNode>{};
    final open = <int, PathNode>{startNode.hashCode: startNode};

    while (true) {
      final curr = open.values.fold<PathNode?>(
            null,
            (previousValue, element) =>
                (previousValue?.fCost ?? double.maxFinite) > element.fCost
                    ? element
                    : previousValue,
          ) ??
          (throw Exception('Incorrect maze configuration'));
      open.remove(curr.hashCode);
      closed[curr.hashCode] = curr;

      if (curr.position == maze.end) {
        break;
      }

      for (final neighbor in neighbors(curr.position)) {
        if (maze.field[neighbor.y][neighbor.x] != '.' ||
            closed[neighbor.hashCode] != null) {
          continue;
        }

        final neighborNode = createNode(
          position: neighbor,
          parent: curr,
        );

        if (open[neighbor.hashCode] case final openNeighbor?
            when neighborNode.fCost >= openNeighbor.fCost) {
          continue;
        }

        open[neighborNode.hashCode] = neighborNode;
      }

      // Reconstruct the path
    }
    final last = closed[maze.end.hashCode]!;

    final result = <Point<int>>[];
    PathNode? curr = last;
    while (curr != null) {
      result.add(curr.position);

      curr = curr.parent;
    }

    return result.reversed.toList();
  }

  PathNode createNode({
    required Point<int> position,
    required PathNode parent,
  }) {
    return PathNode(
      position: position,
      fCost:
          heuristic(position, maze.end) + heuristic(position, parent.position),
      parent: parent,
    );
  }
}

class PathNode {
  PathNode({
    required this.position,
    required this.fCost,
    this.parent,
  });

  final int fCost;
  final Point<int> position;
  final PathNode? parent;

  @override
  int get hashCode => position.hashCode;

  @override
  bool operator ==(Object other) {
    return position == other;
  }
}
