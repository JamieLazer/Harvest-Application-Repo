import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/LineData.dart';

void main() {
  test('LineData constructor initializes year, yield, and name', () {
    DateTime date = DateTime(2021, 1, 1, 1);
    final lineData = LineData(date, 0.75, 'Line 1');
    expect(lineData.time.year, 2021);
    expect(lineData.yield, 0.75);
    expect(lineData.name, 'Line 1');
  });
}
