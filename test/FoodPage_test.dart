import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/views/FoodPage.dart';

void main() {
  test('FoodList widget should be created with correct properties', () {
    // Arrange
    int userID = 1;
    int gardenID = 2;
    List food = ['carrots', 'peppers'];

    // Act
    final foodListWidget = FoodList(userID, gardenID, food);
    final foodListState = foodListWidget.createState();

    // Assert
    expect(foodListWidget.userID, userID);
    expect(foodListWidget.gardenID, gardenID);
    expect(foodListWidget.food, food);
  });
}
