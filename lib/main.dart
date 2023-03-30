import 'package:flutter/material.dart';
import 'package:sample_spacexdata/feature/rockets/ui/rockets_page.dart';
import 'package:sample_spacexdata/res/strings.dart';
import 'package:sample_spacexdata/res/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: context.s.appTitle,
      theme: context.t.dark,
      darkTheme: context.t.dark,
      home: const RocketsPage(),
    );
  }
}
