import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/data/entities/maze.dart';

class MazeRepository {
  const MazeRepository();

  Future<List<Maze>> fetchMazes(String baseUrl) async {
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
  }
}

final mazeRepositoryProvider = Provider((ref) => const MazeRepository());