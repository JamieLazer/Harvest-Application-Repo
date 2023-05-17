import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/Arguments/UserInfoArguments.dart';
import 'package:dartfactory/Arguments/DetailsArguments.dart';

void main() {
  group('DetailsArguments', () {
    final userID = 12;
    final gardens = ['garden1', 'garden2'];
    final name = 'John';
    final surname = 'Doe';

    test('constructor should set properties correctly', () {
      final detailsArguments = DetailsArguments(userID, gardens, name, surname);

      expect(detailsArguments.userID, userID);
      expect(detailsArguments.gardens, gardens);
      expect(detailsArguments.name, name);
      expect(detailsArguments.surname, surname);
    });
  });
}
