import 'package:dartfactory/Arguments/UserInfoArguments.dart';

class ProfileDetailsArguments extends UserInfoArguments{
  String name;
  String surname;
  String email;
  String profilePicture;

  ProfileDetailsArguments(super.userID, super.gardens,this.name,this.surname,this.email,this.profilePicture);
}