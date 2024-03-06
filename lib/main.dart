import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test/application/maze_solver/maze_solver_service.dart';
import 'package:webspark_test/features/navigation/router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          ref.watch(mazeSolverServiceProvider);

          return child!;
        },  
        child: MaterialApp.router(
          theme: createTheme(),
          routerConfig: router,
        ),
      ),
    );
  }

  ThemeData createTheme() {
    return FlexColorScheme.light(
      scheme: FlexScheme.deepPurple,
    ).toTheme.copyWith(
          elevatedButtonTheme: const ElevatedButtonThemeData(
            style: ButtonStyle(
              textStyle: MaterialStatePropertyAll(TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
              padding: MaterialStatePropertyAll(EdgeInsets.all(24)),
            ),
          ),
        );
  }
}
