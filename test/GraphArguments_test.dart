import 'package:dartfactory/Arguments/GraphArguments.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GraphArguments constructor initializes fields', () {
    final graphArgs =
        GraphArguments(123, 456, ['Carrots', 'Tomatoes'], 'Yield');
    expect(graphArgs.userID, 123);
    expect(graphArgs.gardenID, 456);
    expect(graphArgs.food, ['Carrots', 'Tomatoes']);
    expect(graphArgs.focus, 'Yield');
  });
}
