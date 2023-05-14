import 'package:dartfactory/Arguments/UserInfoArguments.dart';

class ProfileDetailsArguments extends UserInfoArguments{
  String name;
  String surname;
  String email;

  ProfileDetailsArguments(super.userID, super.gardens,this.name,this.surname,this.email);
}