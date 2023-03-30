import 'package:dartfactory/views/AddFoodPage.dart';
import 'package:dartfactory/views/SearchFoodPage.dart';
import 'package:dartfactory/views/AddGardenPage.dart';
import 'package:dartfactory/views/CreateAccountPage.dart';
import 'package:dartfactory/views/FoodPage.dart';
import 'package:dartfactory/views/LoginPage.dart';
import 'package:dartfactory/views/UserGardensPage.dart';
import 'package:flutter/material.dart';

import 'views/WelcomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomePage(),
      //All named routes used in the app
      // UNCOMMENT THE LINES BELOW
      // routes: {
      //   '/createAccount': (context) => const CreateAccountPage(),
      //   '/userGardens': (context) => const UserGardensPage(),
      //   '/addGarden': (context) => const AddGardenPage(),
      //   '/loginPage': (context) => const LoginPage(),
      //   '/searchFoodPage': (context) => const SearchFoodPage(),
      //   '/foodPage': (context) => const FoodPage(),
      //   '/addFoodPage': (context) => const AddFoodPage(),
      // },
    );
  }
}
