import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ColorScheme get color => Theme.of(this).colorScheme;
}
