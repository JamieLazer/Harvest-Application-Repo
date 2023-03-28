import 'package:flutter/material.dart';

import 'views/HomePage.dart';
import 'views/welcome_page.dart';
import 'views/CreateAccountPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreateAccountPage(),
    );
  }
}
