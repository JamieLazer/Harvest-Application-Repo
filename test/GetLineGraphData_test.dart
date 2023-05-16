import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/GetLineGraphDataAll.dart';
import 'package:dartfactory/LineData.dart';

void main() {
  test('GetLineGraphData should return valid line graph data', () {
    // Set up test data
    DateTime d1 = DateTime(2021, 1, 1);
    DateTime d2 = DateTime(2021, 2, 1);
    DateTime d3 = DateTime(2022, 1, 1);
    DateTime d4 = DateTime(2022, 2, 1);
    List food = [
      {"HARVEST_DATE": d1, "YIELD_KG": 10, "CATEGORY": "Apples"},
      {"HARVEST_DATE": d2, "YIELD_KG": 20, "CATEGORY": "Oranges"},
      {"HARVEST_DATE": d3, "YIELD_KG": 30, "CATEGORY": "Apples"},
      {"HARVEST_DATE": d4, "YIELD_KG": 40, "CATEGORY": "Oranges"},
    ];
    String category = "CATEGORY";

    // Call the function being tested
    List<List<LineData>> result = GetLineGraphDataAll(food, category);

    // Assert that the result is what we expect
    expect(
        result.length, equals(2)); // We expect 2 categories: Apples and Oranges
    expect(result[0].length,
        equals(2)); // We expect 2 data points for Apples (one for each year)
    expect(result[1].length,
        equals(2)); // We expect 2 data points for Oranges (one for each year)
  });
}
