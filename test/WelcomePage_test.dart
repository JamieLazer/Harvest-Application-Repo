import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/views/WelcomePage.dart';

void main() {
  testWidgets('WelcomePage displays welcome message',
      (WidgetTester tester) async {
    // Build the widget tree.
    await tester.pumpWidget(const MaterialApp(home: WelcomePage()));

    // Find the welcome message text widget.
    final welcomeMessage = find.text('Welcome to Harvest!');

    // Verify that the welcome message is displayed with the correct style.
    expect(welcomeMessage, findsOneWidget);

    final welcomeMessage2 = find.text(
        'Track your harvest yields, view previous yields and share gardens with other users');

    // Verify that the welcome message is displayed with the correct style.
    expect(welcomeMessage2, findsOneWidget);
  });
}
