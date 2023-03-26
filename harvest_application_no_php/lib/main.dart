import 'package:flutter/material.dart';
import 'package:harvest_application_no_php/views/login_page.dart';

import 'views/welcome_page.dart';
import './views/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
