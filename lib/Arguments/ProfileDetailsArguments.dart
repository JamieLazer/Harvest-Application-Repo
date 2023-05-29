import 'package:dartfactory/Arguments/UserInfoArguments.dart';

class ProfileDetailsArguments extends UserInfoArguments{
  String name;
  String surname;
  String email;
  String password;
  String profilePicture;

  ProfileDetailsArguments(super.userID, this.password, super.gardens,this.name,this.surname,this.email,this.profilePicture);
}