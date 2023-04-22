import 'package:dartfactory/views/LoginPage.dart';
import 'package:test/test.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  test('getConnection() returns a MySqlConnection', () async {
    // Act
    var result = await getConnection();

    // Assert
    expect(result, isA<MySqlConnection>());
  });

  test('Test login with correct email and password', () async {
    // Arrange
    final email = 'unittest@gmail.com';
    final password = 'test123';
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
    final email = 'unittest@gmail.com';
    final password = 'Unitest';
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
}
