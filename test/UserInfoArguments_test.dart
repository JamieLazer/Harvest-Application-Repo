import 'package:dartfactory/Arguments/UserInfoArguments.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserInfoArguments', () {
    test('should create UserInfoArguments with provided userID and gardens list', () {
      // arrange
      const userID = 123;
      final gardens = ['garden1', 'garden2'];

      // act
      final userInfoArgs = UserInfoArguments(userID, gardens);

      // assert
      expect(userInfoArgs.userID, equals(userID));
      expect(userInfoArgs.gardens, equals(gardens));
    });
  });
}
