import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/GetLineGraphDataAll.dart';
import 'package:dartfactory/LineData.dart';

void main() {
  test('GetLineGraphData should return valid line graph data', () {
    // Set up test data
    List food = [
      {"HARVEST_DATE": "2021-01-01", "YIELD_KG": 10, "CATEGORY": "Apples"},
      {"HARVEST_DATE": "2021-02-01", "YIELD_KG": 20, "CATEGORY": "Oranges"},
      {"HARVEST_DATE": "2022-01-01", "YIELD_KG": 30, "CATEGORY": "Apples"},
      {"HARVEST_DATE": "2022-02-01", "YIELD_KG": 40, "CATEGORY": "Oranges"},
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
