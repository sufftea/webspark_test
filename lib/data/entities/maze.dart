import 'dart:html';
import 'dart:math';

class Maze {
  Maze({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  final String id;
  final String field;
  final Point start;
  final Point end;

  factory Maze.fromJson(dynamic json) {
    if (json
        case {
          'id': String id,
          'field': String field,
          'start': {
            'x': int startX,
            'y': int startY,
          },
          'end': {
            'x': int endX,
            'y': int endY,
          },
        }) {
      return Maze(
        id: id,
        field: field,
        start: Point(startX, startY),
        end: Point(endX, endY),
      );
    } else {
      throw Exception("Couldn't parse response: $json");
    }
  }
}
