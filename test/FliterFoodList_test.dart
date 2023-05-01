import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/views/FilterFoodList.dart';
void main() {
  test('Test FilterFoodList', () {
    // Arrange
    List<Map<String, dynamic>> food = [
      {'name': 'Pizza', 'category': 'Italian'},
      {'name': 'Sushi', 'category': 'Japanese'},
      {'name': 'Taco', 'category': 'Mexican'},
      {'name': 'Burger', 'category': 'American'},
    ];
    String category = 'category';
    String filter = 'Italian';

    // Act
    List<Map<String, dynamic>> filteredFood = FilterFoodList(food, category, filter);

    // Assert
    expect(filteredFood.length, 1);
    expect(filteredFood[0]['name'], 'Pizza');
    expect(filteredFood[0]['category'], 'Italian');
  });
}
