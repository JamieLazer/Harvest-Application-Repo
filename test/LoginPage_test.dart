import 'package:dartfactory/views/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mysql1/mysql1.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  test('getConnection() returns a MySqlConnection', () async {
    // Act
    var result = await getConnection();

    // Assert
    expect(result, isA<MySqlConnection>());
  });

  test('Test login with correct email and password', () async {
    // Arrange
    const email = 'unittest@gmail.com';
    const password = 'test123';
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'db4free.net',
        port: 3306,
        user: 'hardcoded',
        password: '5Scrummies@SD',
        db: 'harvestapp'));

    // Insert a test user into the database
    await conn.query(
        'INSERT INTO USERS (user_email, user_password) VALUES (?, ?)',
        [email, password]);

    // Act
    final result = await login(email, password);

    // Assert
    expect(result, true);

    // Cleanup
    await conn.query(
        'DELETE FROM USERS WHERE user_email = ? AND user_password = ?',
        [email, password]);
    await conn.close();
  });

  test('Test login with incorrect email or password', () async {
    // Arrange
    const email = 'unittest@gmail.com';
    const password = 'Unitest';
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'db4free.net',
        port: 3306,
        user: 'hardcoded',
        password: '5Scrummies@SD',
        db: 'harvestapp'));

    // Insert a test user into the database
    await conn.query(
        'INSERT INTO USERS (user_email, user_password) VALUES (?, ?)',
        [email, password]);

    // Act
    final result1 = await login(email, 'wrongpassword');
    final result2 = await login('wrongemail@example.com', password);

    // Assert
    expect(result1, false);
    expect(result2, false);

    // Cleanup
    await conn.query(
        'DELETE FROM USERS WHERE user_email = ? AND user_password = ?',
        [email, password]);
    await conn.close();
  });
  group('Login page widgets', () {
    testWidgets('buildEmail widget', (WidgetTester tester) async {
      final emailController = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: buildEmail(emailController),
            ),
          ),
        ),
      );
      // check if the email label is present
      expect(find.text('Email'), findsOneWidget);

      // enter text in the email field
      await tester.enterText(find.byType(TextFormField), 'email@test.com');
      expect(emailController.text, 'email@test.com');
    });

    testWidgets('buildPassword widget', (WidgetTester tester) async {
      final passwordController = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: buildPassword(passwordController),
            ),
          ),
        ),
      );

      // check if the password label is present
      expect(find.text('Password'), findsOneWidget);

      // enter text in the password field
      await tester.enterText(find.byType(TextFormField), 'testpassword');
      expect(passwordController.text, 'testpassword');
    });

    testWidgets('buildLoginButton widget', (WidgetTester tester) async {
      final emailController = TextEditingController();
      final passwordController = TextEditingController();
      final formKey = GlobalKey<FormState>();
      final BuildContext context = MockBuildContext();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: buildLoginButton(
                  emailController, passwordController, formKey, context),
            ),
          ),
        ),
      );

      // check if the login button is present
      expect(find.text('log in'), findsOneWidget);
    });
  });
}
