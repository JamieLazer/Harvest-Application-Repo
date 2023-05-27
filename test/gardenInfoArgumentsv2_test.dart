import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/Arguments/gardenInfoArgumentsv2.dart';

void main() {
  group('gardenInfoArgs', () {
    final userID = 23;
    final gardenID = 123;
    final food = ['grapes', 'apples'];
    final gardenName = 'My Garden';
    final atlas = ['apple', 'hjdhd'];
    test('constructor should set properties correctly', () {
      final gardenArgs =
          gardenInfoArgs(userID, gardenID, food, gardenName, atlas);

      expect(gardenArgs.userID, userID);
      expect(gardenArgs.gardenID, gardenID);
      expect(gardenArgs.food, food);
      expect(gardenArgs.gardenName, gardenName);
      expect(gardenArgs.atlas, atlas);
    });
  });
}
