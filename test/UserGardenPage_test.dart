import 'package:dartfactory/Arguments/UserInfoArguments.dart';
import 'package:dartfactory/main.dart';
import 'package:dartfactory/views/FoodPage.dart';
import 'package:dartfactory/views/LoginPage.dart';
import 'package:dartfactory/views/UserGardensPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  testWidgets("no gardens", (WidgetTester tester) async {
    //Here I pumped the widget directly without having a variable, see navigation test below
    await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text(
              "You have not added any gardens yet",
              key: Key("noGarden text"),
            ),
          ),
        )
    );
    final textWidget = find.byKey(Key("noGarden text"));
    expect(textWidget, findsOneWidget);
    expect(tester
        .widget<Text>(textWidget)
        .data, "You have not added any gardens yet");
  });
  testWidgets("check if list of gardens show ", (WidgetTester tester) async {
    const listkey = Key("listBuilder");
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        key: listkey,
        body: UserGardensList(2, []),
      ),
    ));
    expect(find.byKey(listkey), findsOneWidget);
  });

}
