import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/features/solution_preview/solution_preview_provider.dart';
import 'package:webspark_test/features/solution_preview/solution_preview_state.dart';
import 'package:webspark_test/features/utils/extensions.dart';

class SolutionPreviewScreen extends StatelessWidget {
  const SolutionPreviewScreen({
    required this.solutionId,
    super.key,
  });

  final String solutionId;

  static const routeName = 'preview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: SingleChildScrollView(
        child: Consumer(builder: (context, ref, child) {
          final solution = ref.watch(solutionPreviewProvider(solutionId));

          if (solution == null) {
            return const SizedBox.shrink();
          }

          return LayoutBuilder(builder: (context, cons) {
            final size = cons.biggest.width / solution.maze.field.first.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int y = 0; y < solution.maze.field.length; y++)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      for (int x = 0; x < solution.maze.field.first.length; x++)
                        buildCell(
                          context,
                          solution: solution,
                          p: Point(x, y),
                          size: size,
                        ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      solution.pathString,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        }),
      ),
    );
  }

  Widget buildCell(
    BuildContext context, {
    required SolutionPreviewState solution,
    required Point<int> p,
    required double size,
  }) {
    solution.pathPoints.contains(p);
    p == solution.maze.start;

    final isWall = solution.maze.field[p.y][p.x] == 'X';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.color.onBackground,
          width: 1,
        ),
        color: switch (true) {
          _ when p == solution.maze.start => const Color(0xFF64FFDA),
          _ when p == solution.maze.end => const Color(0xFF009688),
          _ when solution.pathPoints.contains(p) => const Color(0xFF4CAF50),
          _ when isWall => Colors.black,
          _ => Colors.transparent,
        },
      ),
      child: size > 20
          ? Center(
              child: Text(
                '(${p.x},${p.y})',
                style: TextStyle(
                  color: isWall ? Colors.white : context.color.onBackground,
                ),
              ),
            )
          : null,
    );
  }
}
