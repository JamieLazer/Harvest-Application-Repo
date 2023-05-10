import 'package:dartfactory/Arguments/UserInfoArguments.dart';

class DetailsArguments extends UserInfoArguments{
  String name;
  String surname;
  DetailsArguments(super.userID, super.gardens,this.name,this.surname);

}