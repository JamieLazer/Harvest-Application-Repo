import 'package:dartfactory/views/UserGardensPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartfactory/views/AddFoodPage.dart';

// Mock NavigatorObserver
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
    testWidgets('should show error when input is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddFoodForm(1, 2, const [], ''),
          ),
        ),
      );

      // Verify that validator is working
      expect(find.text('This field cannot be empty'), findsNothing);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('This field cannot be empty'), findsOneWidget);
    });
}
void main2(){
  testWidgets("add a gardenv2", (WidgetTester tester) async{
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserGardensList(2,["Jamie"]),
        ),
      )
    );
    expect(find.byKey(Key("listBuilder")), findsOneWidget);
  });
}