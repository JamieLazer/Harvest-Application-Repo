import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/PieData.dart';

void main() {
  test('PieData constructor initializes name and yield', () {
    final pieData = PieData('Apple', 0.75);
    expect(pieData.name, 'Apple');
    expect(pieData.yield, 0.75);
  });
}
