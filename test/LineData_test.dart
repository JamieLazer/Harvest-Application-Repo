import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/LineData.dart';

void main() {
  test('LineData constructor initializes year, yield, and name', () {
    final lineData = LineData(2021, 0.75, 'Line 1');
    expect(lineData.year, 2021);
    expect(lineData.yield, 0.75);
    expect(lineData.name, 'Line 1');
  });
}
