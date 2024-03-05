import 'package:dio/dio.dart';
import 'package:webspark_test/data/entities/maze.dart';

class MazeRepository {
  MazeRepository(String baseUrl)
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
        ));

  final Dio _dio;

  Future<List<Maze>> fetchMazes() async {
    final response = await _dio.get('/flutter/api');

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
