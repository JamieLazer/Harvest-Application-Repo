import 'package:dartfactory/ConnectionSettings.dart';
import 'package:dartfactory/styles.dart';
import 'package:dartfactory/views/ProfilePage.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';
import '../Arguments/GardenInfoArguments.dart';
import '../Arguments/UserInfoArguments.dart';
import 'package:dartfactory/views/WelcomePage.dart';
// import 'package:side_menu_controller/side_menu_controller.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColour,
            ),
            child: Text('Name Surname'),
          ),
          ListTile(
            title: const Text('Gardens'),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

              // To the Profile Page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

              // Back to Welcome
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class UserGardensPage extends StatelessWidget {
  const UserGardensPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
        ModalRoute.of(context)!.settings.arguments as UserInfoArguments;
    //Extract the user's ID and gardens from the arguments
    List gardens = arguments.gardens;
    int userID = arguments.userID;

    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      appBar: AppBar(
        //This is the title at the top of the screen
        title: const Text('My Gardens',
          style: welcomePageText
          ),
        backgroundColor: primaryColour,
        automaticallyImplyLeading: false, //remove back
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
                onPressed: () async {
                  //What happens when the + is tapped
                  //Create the arguments that we will pass to the next page
                  UserInfoArguments args = UserInfoArguments(arguments.userID, arguments.gardens);
                  //Navigate to the add garden screen using a named route.
                  Navigator.pushNamed(context, '/addGarden', arguments: args);
                },
            ),
        ],
      ),
      //The body is filled with the UserGardensList class below
      //gardens has been passed to the UserGardenList to ensure we can use this variable in that widget
      body: Column(
        children: [
          Expanded(
            child: UserGardensList(userID, gardens),
          ),
        ],
      ),
      drawer: const SideMenu(),
    );
  }
}

class UserGardensList extends StatefulWidget {
  //We have to initialise the variables
  List gardens = [];
  int userID = 0;

  //Constructor
  UserGardensList(int passedUserID, List passedGardens, {super.key}) {
    userID = passedUserID;
    gardens = passedGardens;
  }

  @override
  State<UserGardensList> createState() => _UserGardensState(userID, gardens);
}

//This class holds data related to the list
class _UserGardensState extends State<UserGardensList> {
  //We have to initialise the variable before getting it from the constructor
  List gardens = [];
  int userID = 0;

  //Constructor
  _UserGardensState(int passedUserID, List passedGardens) {
    userID = passedUserID;
    gardens = passedGardens;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Scaffold(
        //First check if the user has any gardens
        //If they don't display the message below
        backgroundColor: Colors.white10,
        body: gardens.isEmpty
            ? const Center(
                child: Text(
                  "You have not added any gardens yet",
                  style: blackText,
                ),
              )
            //We use ListView.Builder so that we don't have to know the number of gardens beforehand
            : ListView.builder(
                itemCount: gardens.length,
                itemBuilder: (context, index) => Card(
                  //Design of each list item
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  // elevation: 0.01,
                  color: tertiaryColour.withOpacity(0.5),
                  child: ListTile(
                    //Setting the visualDensity to a positive number will increase the ListTile height, whereas a negative number will decrease the height
                    //The maximum and minimum values you can set it to are 4 and -4
                    visualDensity: const VisualDensity(vertical: 4),
                    tileColor: Colors.transparent,
                    //This determines the text in the list tile
                    title: Text(
                      gardens[index]["LOG_NAME"],
                      style: blackText.copyWith(color: secondaryColour),
                    ),
                    trailing: IconButton(
                      color: secondaryColour, 
                      icon: const Icon(Icons.arrow_forward_ios_rounded), 
                      onPressed: () async {
                        var conn = await MySqlConnection.connect(settings);
                        //Make a request for the food in this garden
                        var results = await conn.query(
                            'select * from YIELD where LOG_ID = ? ORDER BY HARVEST_DATE DESC',
                          [gardens[index]["LOG_ID"]]);
                        //Convert the results of the database query to a list
                        List foodList = results.toList();
                        //Create the arguments that we will pass to the next page
                        GardenInfoArguments args = GardenInfoArguments(
                          userID, gardens[index]["LOG_ID"], foodList);
                        //Navigate to the add garden screen using a named route.
                        Navigator.pushNamed(context, '/foodPage', arguments: args);
                      },
                    ),
                    leading: IconButton(
                      color: secondaryColour, 
                      icon: const Icon(Icons.analytics_outlined), 
                      onPressed: () async {
                        var conn = await MySqlConnection.connect(settings);
                        //Make a request for the food in this garden
                        var results = await conn.query(
                          'select * from YIELD where LOG_ID = ? order by HARVEST_DATE ASC',
                          [gardens[index]["LOG_ID"]]);
                        //Convert the results of the database query to a list
                        List foodList = results.toList();
                        //Create the arguments that we will pass to the next page
                        GardenInfoArguments args = GardenInfoArguments(
                          userID, gardens[index]["LOG_ID"], foodList);
                        //Navigate to the add garden screen using a named route.
                        Navigator.pushNamed(context, '/analyticsPage', arguments: args);
                      },
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
