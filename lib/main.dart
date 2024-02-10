import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spit_hack_2024/firebase_options.dart';
import 'package:spit_hack_2024/presentation/home_page.dart';

import 'presentation/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subscription Sharing',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
