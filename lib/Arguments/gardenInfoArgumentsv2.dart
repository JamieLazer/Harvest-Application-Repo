import 'package:dartfactory/Arguments/GardenInfoArguments.dart';

class gardenInfoArgs extends GardenInfoArguments{
  String gardenName;
  List atlas;
  gardenInfoArgs(super.userID, super.gardenID, super.food,this.gardenName,this.atlas);

}