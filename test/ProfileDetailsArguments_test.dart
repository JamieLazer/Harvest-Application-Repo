import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/Arguments/ProfileDetailsArguments.dart';

void main() {
  group('Profile details arguments', () {
    final userID = 1;
    final gardens = ['applegarden', 'apricot garden'];
    final name = 'Ribi';
    final surname = 'TheCat';
    final email = 'ribi@gmail.com';
    test('constructor should set properties correctly', () {
      final ProfileArgs =
          ProfileDetailsArguments(userID, gardens, name, surname, email);

      expect(ProfileArgs.userID, userID);
      expect(ProfileArgs.gardens, gardens);
      expect(ProfileArgs.name, name);
      expect(ProfileArgs.surname, surname);
      expect(ProfileArgs.email, email);
    });
  });
}
