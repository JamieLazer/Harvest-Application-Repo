import 'dart:ffi';

import 'package:dartfactory/styles.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';

import '../Arguments/GardenInfoArguments.dart';
import '../ConnectionSettings.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
    ModalRoute.of(context)!.settings.arguments as GardenInfoArguments;
    //Extract the garden's info from the arguments
    int userID = arguments.userID;
    int gardenID = arguments.gardenID;
    List food = arguments.food;

    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      appBar: AppBar(
        //This is the title at the top of the screen
        title: Text('Harvest', style: welcomePageText,),
        backgroundColor: primaryColour,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 50.0),
              //This adds the + icon on the top right of the appbar
              child: GestureDetector(
                //What happens when the + is tapped
                onTap: () async {
                  var conn = await MySqlConnection.connect(settings);

                  //Make a request for a list of all food items
                  var results = await conn.query(
                    'select * from FOOD'
                  );
                  //Convert the results of the database query to a list
                  List resultsList = results.toList();
                  //Create the arguments that we will pass to the next page
                  GardenInfoArguments args = GardenInfoArguments(userID, gardenID, resultsList);
                  //Navigate to the add food screen using a named route.
                  Navigator.pushNamed(context, '/searchFoodPage', arguments: args);
                },
                //Specifies the design and size of the icon
                child: const Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
        ],
      ),
      //The body is filled with the foodList class below
      //gardens has been passed to the UserGardenList to ensure we can use this variable in that widget
      body: FoodList(userID, gardenID, food),
    );
  }
}

class FoodList extends StatefulWidget {
  //We have to initialise the variable
    int userID = 0;
    int gardenID = 0;
    List food = [];

  //Constructor
  FoodList(int passedUserID, int passedGardenID, List passedFood, {super.key}) {
    this.userID = passedUserID;
    this.gardenID = passedGardenID;
    this.food = passedFood;
  }

  @override
  State<FoodList> createState() => _FoodListState(userID, gardenID, food);
}

//This class holds data related to the list
class _FoodListState extends State<FoodList> {
  //We have to initialise the variable
    int userID = 0;
    int gardenID = 0;
    List food = [];

  //Constructor
  _FoodListState(int passedUserID, int passedGardenID, List passedFood) {
    this.userID = passedUserID;
    this.gardenID = passedGardenID;
    this.food = passedFood;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //First check if the user has any food in the garden
      //If they don't display the message below
      body: food.isEmpty
          ? const Center(
        child: Text("You have not added any crops yet", style: blackText,),
      )
      //We use ListView.Builder so that we don't have to know the number of gardens beforehand
          : ListView.builder(
        itemCount: food.length,
        itemBuilder: (context, index) => Card(
          //Design of each list item
          child: ListTile(
            //Setting the visualDensity to a positive number will increase the ListTile height, whereas a negative number will decrease the height
            //The maximum and minimum values you can set it to are 4 and -4
            visualDensity: VisualDensity(vertical: 4),
            //This determines the text in the list tile
            title: Text(food[index]["YIELD_NAME"], style: secondaryColourText,),
            trailing: Text('${food[index]["YIELD_KG"]} kg', style: secondaryColourText,),
            subtitle: Text('This was harvested on ${food[index]["HARVEST_DATE"]}', style: blackText.copyWith( color: Colors.black54),),
          ),
        ),
      ),
    );
  }
}
