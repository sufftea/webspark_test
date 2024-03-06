import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webspark_test/data/entities/solved_maze.dart';
import 'package:webspark_test/features/solution_preview/solution_preview_screen.dart';

class SolutionEntryWidget extends StatelessWidget {
  const SolutionEntryWidget({
    required this.solution,
    super.key,
  });

  final MazeSolution solution;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.pushNamed(
          SolutionPreviewScreen.routeName,
          pathParameters: {'id': solution.maze.id},
        );
      },
      style: const ButtonStyle(
        fixedSize: MaterialStatePropertyAll(Size.fromHeight(64)),
      ),
      child: Text(solution.pathString),
    );
  }
}
