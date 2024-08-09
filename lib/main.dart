import 'package:flutter/material.dart';
import 'package:spit_hack_2024/presentation/home_page.dart';

void main() async {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EVOL',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
      ),
      home: const HomePage(),
    );
  }
}
