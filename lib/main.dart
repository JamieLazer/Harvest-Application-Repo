import 'package:dartfactory/views/AddFoodPage.dart';
import 'package:dartfactory/views/AnalyticsPage.dart';
import 'package:dartfactory/views/FoodLineGraphPage.dart';
import 'package:dartfactory/views/FoodPieChartPage.dart';
import 'package:dartfactory/views/SubtypeLineGraphPage.dart';
import 'package:dartfactory/views/SupertypeLineGraphPage.dart';
import 'package:dartfactory/views/SearchFoodPage.dart';
import 'package:dartfactory/views/AddGardenPage.dart';
import 'package:dartfactory/views/CreateAccountPage.dart';
import 'package:dartfactory/views/FoodPage.dart';
import 'package:dartfactory/views/LoginPage.dart';
import 'package:dartfactory/views/TypeLineGraphPage.dart';
import 'package:dartfactory/views/UserGardensPage.dart';
import 'package:dartfactory/views/SupertypePieChartPage.dart';
import 'package:dartfactory/views/UserPage.dart';
import 'package:flutter/material.dart';
import 'views/SubtypePieChartPage.dart';
import 'views/TypePieChartPage.dart';
import 'views/WelcomePage.dart';
import 'views/ProfilePage.dart';
import 'views/ChangePasswordPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
      routes: {
        '/createAccount': (context) => const CreateAccountPage(),
        '/userGardens': (context) => const UserGardensPage(),
        '/profile': (context) => const ProfilePage(),
        '/changePassword': (context) => const ChangePassword(),
        '/addGarden': (context) => const AddGardenPage(),
        '/loginPage': (context) => const LoginPage(),
        '/searchFoodPage': (context) => const SearchFoodPage(),
        '/foodPage': (context) => const FoodPage(),
        '/addFoodPage': (context) => const AddFoodPage(),
        '/analyticsPage': (context) => const AnalyticsPage(),
        '/supertypePieChartPage': (context) => const SupertypePieChartPage(),
        '/typePieChartPage': (context) => const TypePieChartPage(),
        '/subtypePieChartPage': (context) => const SubtypePieChartPage(),
        '/foodPieChartPage': (context) => const FoodPieChartPage(),
        '/supertypeLineGraphPage': (context) => const SupertypeLineGraphPage(),
        '/typeLineGraphPage': (context) => const TypeLineGraphPage(),
        '/subtypeLineGraphPage': (context) => const SubtypeLineGraphPage(),
        '/foodLineGraphPage': (context) => const FoodLineGraphPage(),
        '/userPage':(context)=> const UserPage(),
       },
    );
  }
}
