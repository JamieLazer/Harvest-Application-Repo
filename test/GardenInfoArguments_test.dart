import 'package:dartfactory/Arguments/GardenInfoArguments.dart';
import 'package:test/test.dart';

void main() {
  group('GardenInfoArguments tests', () {
    test('should create a GardenInfoArguments instance with userID, gardenID, and food list', () {
      final arguments = GardenInfoArguments(1, 2, ['Tomatoes', 'Peppers']);

      expect(arguments.userID, equals(1));
      expect(arguments.gardenID, equals(2));
      expect(arguments.food, equals(['Tomatoes', 'Peppers']));
    });
    });
}
