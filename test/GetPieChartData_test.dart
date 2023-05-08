import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/GetPieChartData.dart';
import 'package:dartfactory/PieData.dart';

void main() {
  test('GetPieChartData returns correct data', () {
    final foodList = [
      {'name': 'Carrots', 'category': 'Vegetables', 'YIELD_KG': 10.0},
      {'name': 'Apples', 'category': 'Fruit', 'YIELD_KG': 5.0},
      {'name': 'Lettuce', 'category': 'Vegetables', 'YIELD_KG': 7.0},
      {'name': 'Oranges', 'category': 'Fruit', 'YIELD_KG': 3.0}
    ];
    final pieChartData = GetPieChartData(foodList, 'category');
    expect(pieChartData.length, 2);
    expect(pieChartData[0].name, 'Vegetables');
    expect(pieChartData[0].yield, 17.0);
    expect(pieChartData[1].name, 'Fruit');
    expect(pieChartData[1].yield, 8.0);
  });

  test('GetPieChartData returns empty list if food list is empty', () {
    final foodList = [];
    final pieChartData = GetPieChartData(foodList, 'category');
    expect(pieChartData.length, 0);
  });
}
