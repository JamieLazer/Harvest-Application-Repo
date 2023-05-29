import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/Arguments/ProfileDetailsArguments.dart';

void main() {
  group('Profile details arguments', () {
    const userID = 1;
    final gardens = ['applegarden', 'apricot garden'];
    const name = 'Ribi';
    const surname = 'TheCat';
    const email = 'ribi@gmail.com';
    const password = 'pswd';
    const profilePicture = '1010101';
    test('constructor should set properties correctly', () {
      final ProfileArgs =
          ProfileDetailsArguments(userID, password, gardens, name, surname, email, profilePicture);

      expect(ProfileArgs.userID, userID);
      expect(ProfileArgs.gardens, gardens);
      expect(ProfileArgs.name, name);
      expect(ProfileArgs.surname, surname);
      expect(ProfileArgs.email, email);
      expect(ProfileArgs.password, password);
    });
  });
}
