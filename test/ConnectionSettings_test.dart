// Import the test package and Counter class
import 'package:dartfactory/ConnectionSettings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Connection Settings', () {
    test('Host should be db4free.net', () {
      expect(settings.host, 'db4free.net');
    });

    test('Port should be 3306', () {
      expect(settings.port, 3306);
    });

    test('User should be hardcoded', () {
      expect(settings.user, 'hardcoded');
    });

    test('Password should be 5Scrummies@SD', () {
      expect(settings.password, '5Scrummies@SD');
    });

    test('Database should be harvestapp', () {
      expect(settings.db, 'harvestapp');
    });
  });
}