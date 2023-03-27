import 'package:flutter/material.dart';

import 'views/login_page.dart';
import 'views/welcome_page.dart';
import 'views/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpPage(),
    );
  }
}
