import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/FilterFoodList.dart';

void main() {
  test('FilterFoodList removes items not matching filter', () {
    final foodList = [
      {'name': 'Carrots', 'category': 'Vegetables'},
      {'name': 'Apples', 'category': 'Fruit'},
      {'name': 'Lettuce', 'category': 'Vegetables'},
      {'name': 'Oranges', 'category': 'Fruit'}
    ];
    final filteredList = FilterFoodList(foodList, 'category', 'Fruit');
    expect(filteredList.length, 2);
    expect(filteredList[0]['name'], 'Apples');
    expect(filteredList[1]['name'], 'Oranges');
  });

  test('FilterFoodList returns empty list if all items are filtered', () {
    final foodList = [
      {'name': 'Carrots', 'category': 'Vegetables'},
      {'name': 'Lettuce', 'category': 'Vegetables'}
    ];
    final filteredList = FilterFoodList(foodList, 'category', 'Fruit');
    expect(filteredList.length, 0);
  });
}
