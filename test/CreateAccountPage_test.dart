import 'package:dartfactory/views/CreateAccountPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:email_validator/email_validator.dart';
import 'package:dartfactory/views/LoginPage.dart';

void main() {
  testWidgets('Create Account Form Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Material(
          child: CreateAccountForm(),
        ),
      ),
    );

    final firstNameFinder = find.widgetWithText(TextFormField, 'First Name');
    expect(firstNameFinder, findsOneWidget);

    final lastNameFinder = find.widgetWithText(TextFormField, 'Last Name');
    expect(lastNameFinder, findsOneWidget);

    final emailFinder = find.widgetWithText(TextFormField, 'Email Address');
    expect(emailFinder, findsOneWidget);

    final passwordFinder = find.widgetWithText(TextFormField, 'Password');
    expect(passwordFinder, findsOneWidget);

    await tester.tap(firstNameFinder);
    await tester.enterText(firstNameFinder, 'Test');
    await tester.pump();

    await tester.tap(lastNameFinder);
    await tester.enterText(lastNameFinder, 'User');
    await tester.pump();

    await tester.tap(emailFinder);
    await tester.enterText(emailFinder, 'testuser@gmail.com');
    await tester.pump();

    await tester.tap(passwordFinder);
    await tester.enterText(passwordFinder, 'test123');
    await tester.pump();

    final createAccountButtonFinder =
    find.widgetWithText(ElevatedButton, 'SIGN UP');
    expect(createAccountButtonFinder, findsOneWidget);

    // await tester.tap(createAccountButtonFinder);
    // await tester.pumpAndSettle();

    //expect(find.text(''), findsOneWidget);
  });

  test('Empty First Name Validation Test', () {
    final result = validateFirstName('');
    expect(result, 'This field cannot be empty');
  });

  test('Empty Last Name Validation Test', () {
    final result = validateLastName('');
    expect(result, 'This field cannot be empty');
  });

  test('Invalid Email Validation Test', () {
    final result = validateEmail('invalidemail');
    expect(result, 'Please enter valid email');
  });

  test('Empty Email Validation Test', () {
    final result = validateEmail('');
    expect(result, 'This field cannot be empty');
  });

  test('Valid Email Validation Test', () {
    final result = validateEmail('test@example.com');
    expect(result, null);
  });

  test('Empty Password Validation Test', () {
    final result = validatePassword('');
    expect(result, 'This field cannot be empty');
  });

  test('Short Password Validation Test', () {
    final result = validatePassword('test');
    expect(result, 'Password must be at least 6 characters');
  });

  test('Valid Password Validation Test', () {
    final result = validatePassword('test123');
    expect(result, null);
  });
  
  testWidgets('Clicking Login In Here navigates to LoginPage',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CreateAccountPage(),
        ),
      ),
    );
    await tester.tap(find.text('Log In Here'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
  });
}

String? validateFirstName(String value) {
  if (value.isEmpty) {
    return 'This field cannot be empty';
  }
  return null;
}

String? validateLastName(String value) {
  if (value.isEmpty) {
    return 'This field cannot be empty';
  }
  return null;
}

String? validateEmail(String value) {
  if (value.isEmpty) {
    return 'This field cannot be empty';
  } else if (!EmailValidator.validate(value)) {
    return 'Please enter valid email';
  }
  return null;
}

String? validatePassword(String value) {
  if (value.isEmpty) {
    return 'This field cannot be empty';
  } else if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}
