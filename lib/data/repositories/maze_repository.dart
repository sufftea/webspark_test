import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/data/entities/maze.dart';
import 'package:webspark_test/data/entities/solved_maze.dart';

class MazeRepository {
  const MazeRepository(this.baseUrl);

  final String baseUrl;

  Future<List<Maze>> fetchMazes() async {
    try {
      final response = await Dio().get(baseUrl);

      if (response.data
          case {
            'error': bool error,
            'message': String message,
            'data': final data,
          }) {
        if (error) {
          throw Exception(message);
        }

        if (data is! List) {
          throw Exception("Couldn't parse response: $data");
        }

        return [
          for (final maze in data) Maze.fromJson(maze),
        ];
      } else {
        throw Exception("Couldn't parse response: $response");
      }
    } on DioException catch (e) {
      throw Exception("Couldn't fetch mazes: ${e.message}");
    }
  }

  Future<void> sendResult(List<MazeSolution> solutions) async {
    final data = jsonEncode([
      for (final solution in solutions)
        {
          'id': solution.maze.id,
          'result': {
            'steps': [
              for (final point in solution.path)
                {
                  'x': point.x,
                  'y': point.y,
                }
            ],
            'path': solution.pathString,
          },
        },
    ]);

    try {
      final response = await Dio().post(baseUrl, data: data);
      if (response.data
          case {
            'error': final error,
            'message': final message,
          }) {
        if (error) {
          throw Exception(message);
        }
      } else {
        throw Exception(
          'Unexpected response from the server',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Error occured when sending requests to server: ${e.message}',
      );
    }
  }
}

final mazeRepositoryProvider = Provider.family<MazeRepository, String>(
  (ref, baseUrl) => MazeRepository(baseUrl),
);
