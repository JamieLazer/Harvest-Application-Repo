import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/GetLineGraphData.dart';
import 'package:dartfactory/LineData.dart';

void main() {
  group('GetLineGraphData tests', () {
    final food = [
      {"HARVEST_DATE": "2020-06-05", "YIELD_KG": 10, "category": "Category A"},
      {"HARVEST_DATE": "2020-06-06", "YIELD_KG": 20, "category": "Category A"},
      {"HARVEST_DATE": "2020-06-05", "YIELD_KG": 15, "category": "Category B"},
      {"HARVEST_DATE": "2020-06-06", "YIELD_KG": 25, "category": "Category B"},
      {"HARVEST_DATE": "2020-06-07", "YIELD_KG": 30, "category": "Category C"}
    ];

    final expectedData = [
      [
        LineData(2020, 30, "Category A"),
        LineData(2020, 25, "Category B"),
        LineData(2020, 0, "Category C")
      ],
      [
        LineData(2020, 0, "Category A"),
        LineData(2020, 0, "Category B"),
        LineData(2020, 30, "Category C")
      ],
      [
        LineData(2020, 0, "Category A"),
        LineData(2020, 0, "Category B"),
        LineData(2020, 0, "Category C")
      ]
    ];

    test('Test GetLineGraphData', () {
      final result = GetLineGraphData(food, "category");
      expect(result.length, equals(expectedData.length));
      for (var i = 0; i < result.length; i++) {
        expect(result[i].length, equals(expectedData[i].length));
        for (var j = 0; j < result[i].length; j++) {
          expect(result[i][j].year, equals(expectedData[i][j].year));
          expect(result[i][j].yield, equals(expectedData[i][j].yield));
          expect(result[i][j].name, equals(expectedData[i][j].name));
        }
      }
    });
  });
}
