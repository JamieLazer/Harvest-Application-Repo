

import 'package:dartfactory/Arguments/UserInfoArguments.dart';
import 'package:dartfactory/main.dart';
import 'package:dartfactory/views/FoodPage.dart';
import 'package:dartfactory/views/LoginPage.dart';
import 'package:dartfactory/views/UserGardensPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  testWidgets("no gardens", (WidgetTester tester) async {
    //The test takes UsergardensPage as home, so I had to supply static values for
    //UserInfoArguments
    await tester.pumpWidget(const MaterialApp(
        home: UserGardensPage(),
    ));
      // Verify that the icon button is present in the app bar

      expect(find.text("You have not added any gardens yet"),findsOneWidget);
    });
  testWidgets("Check if title shows as it should", (WidgetTester tester) async{
    await tester.pumpWidget(const MaterialApp(
      home: UserGardensPage(),
    ));
    expect(find.text("My Gardens"), findsOneWidget);
  });
  testWidgets("Check if drawer button shows as it should", (WidgetTester tester) async{
    await tester.pumpWidget(const MaterialApp(
      home: UserGardensPage(),
    ));
    expect(find.byKey(Key("drawerButton")), findsOneWidget);
  });
  testWidgets("Check if add button shows as it should", (WidgetTester tester) async{
    await tester.pumpWidget(const MaterialApp(
      home: UserGardensPage(),
    ));
    expect(find.byKey(Key("addIconKey")), findsOneWidget);
  });

    
}
