import 'package:dartfactory/views/AddGardenPage.dart';
import 'package:dartfactory/views/CreateAccountPage.dart';
import 'package:dartfactory/views/HomePage.dart';
import 'package:dartfactory/views/UserGardensPage.dart';
import 'package:flutter/material.dart';

import 'views/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomePage(),
      routes: {
        //When navigating to the "/createAccount" route, open the CreateAccountPage.
        '/createAccount': (context) => const CreateAccountPage(),
        '/userGardens': (context) => const UserGardensPage(),
        '/addGarden': (context) => const AddGardenPage(),
        '/loginPage': (context) => const LoginPage(),
      },
    );
  }
}
