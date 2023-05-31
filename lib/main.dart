import 'package:dartfactory/views/AddFoodPage.dart';
import 'package:dartfactory/views/AnalyticsPage.dart';
import 'package:dartfactory/views/AtlasViewPage.dart';
import 'package:dartfactory/views/CollaborationRequestsPage.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );
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
        '/invitations':(context)=> const InvitationsScreen(),
        '/atlasPage':(context)=>  AtlasViewPage(),
       },
    );
  }
}
