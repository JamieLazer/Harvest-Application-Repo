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
    testWidgets('AddFoodPage should display the correct widgets',
      (WidgetTester tester) async {
    // Arrange
    final arguments = LogFoodArguments(1, 2, ['carrots', 'peppers'], 'carrots');

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddFoodForm(1, 2, const ['carrots', 'peppers'], 'carrots'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert

    final addFoodForm = tester.widget<AddFoodForm>(find.byType(AddFoodForm));
    expect(addFoodForm.userID, arguments.userID);
    expect(addFoodForm.gardenID, arguments.gardenID);
    expect(addFoodForm.foodList, arguments.foodList);
    expect(addFoodForm.foodName, arguments.foodName);
  });
}
