import 'package:dartfactory/Arguments/LogFoodArguments.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
   group('LogFoodArguments', () {
    test('should create LogFoodArguments with provided userID, gardens ID, foodList and foodName', () {
      // arrange
      const userID = 123;
      const int gardenID = 23;
      const List foodList = ["apple","banana"];
      const String foodName = 'kiwi';

      // act
      final logFood = LogFoodArguments(userID, gardenID, foodList, foodName);

      // assert
      expect(logFood.userID, equals(userID));
      expect(logFood.gardenID, equals(gardenID));
      expect(logFood.foodList, equals(foodList));
      expect(logFood.foodName, equals(foodName));
    });
  });

}
