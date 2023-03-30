import 'package:flutter/material.dart';

extension BuildContextTheme on BuildContext {
  // The context is not needed, but it is used for a seamless
  // potential transition.
  Themes get t => Themes._i;
}

class Themes {
  const Themes._();

  static const Themes _i = Themes._();

  ThemeData get app => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 0, 145, 133),
      );

  ThemeData get dark => ThemeData(brightness: Brightness.dark);
}
