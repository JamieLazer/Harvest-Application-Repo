import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';

import '../UserInfoArguments.dart';

class UserGardensPage extends StatelessWidget {
  const UserGardensPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
        ModalRoute.of(context)!.settings.arguments as UserInfoArguments;
    //Extract the user's gardens from the arguments
    List gardens = arguments.gardens;

    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      appBar: AppBar(
        //This is the title at the top of the screen
        title: const Text('Harvest'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 50.0),
              //This adds the + icon on the top right of the appbar
              child: GestureDetector(
                //What happens when the + is tapped
                onTap: () {
                  //Create the arguments that we will pass to the next page
                  UserInfoArguments args = UserInfoArguments(arguments.userID, arguments.gardens);
                  //Navigate to the add garden screen using a named route.
                  Navigator.pushNamed(context, '/addGarden', arguments: args);
                },
                //Specifies the design and size of the icon
                child: const Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
        ],
      ),
      //The body is filled with the UserGardensList class below
      //gardens has been passed to the UserGardenList to ensure we can use this variable in that widget
      body: UserGardensList(gardens),
    );
  }
}

class UserGardensList extends StatefulWidget {
  //We have to initialise the variable
  List gardens = [];

  //Constructor
  UserGardensList(List passedGardens, {super.key}) {
    this.gardens = passedGardens;
  }

  @override
  State<UserGardensList> createState() => _UserGardensState(gardens);
}

//This class holds data related to the list
class _UserGardensState extends State<UserGardensList> {
  //We have to initialise the variable before getting it from the constructor
  List gardens = [];

  //Constructor
  _UserGardensState(List passedGardens) {
    this.gardens = passedGardens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //First check if the user has any gardens
      //If they don't display the message below
      body: gardens.isEmpty
          ? const Center(
              child: Text("You have not added any gardens yet"),
            )
          //We use ListView.Builder so that we don't have to know the number of gardens beforehand
          : ListView.builder(
              itemCount: gardens.length,
              itemBuilder: (context, index) => Card(
                //Desig of each list item
                child: ListTile(
                  //Setting the visualDensity to a positive number will increase the ListTile height, whereas a negative number will decrease the height
                  //The maximum and minimum values you can set it to are 4 and -4
                  visualDensity: VisualDensity(vertical: 4),
                  //This determines the text in the list tile
                  title: Text(gardens[index]["LOG_NAME"]),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
              ),
            ),
    );
  }
}
