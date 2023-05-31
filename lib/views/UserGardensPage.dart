import 'package:dartfactory/Arguments/ProfileDetailsArguments.dart';
import 'package:dartfactory/Arguments/gardenInfoArgumentsv2.dart';
import 'package:dartfactory/ConnectionSettings.dart';
import 'package:dartfactory/styles.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';
import '../Arguments/GardenInfoArguments.dart';
import '../Arguments/UserInfoArguments.dart';
import 'package:dartfactory/views/WelcomePage.dart';
import 'ChangePasswordPage.dart';
import 'CollaborationRequestsPage.dart';
import 'ProfilePage.dart';

class SideMenu extends StatelessWidget {

  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
    ModalRoute.of(context)!.settings.arguments as ProfileDetailsArguments;
    //Extract the user's ID and gardens from the arguments
    int user_id = arguments.userID;
    String name = arguments.name;
    String surname = arguments.surname;
    String curr_user_email = arguments.email;
    List gardens = arguments.gardens;
    String password = arguments.password;
    String profilePicture = arguments.profilePicture;

    //drawer widget: side menu
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColour,
            ),
            child: Column(
              children: [
                //profile photo
                CircleAvatar(
                  radius: 50,
                  backgroundColor: secondaryColour,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                //user names
                Text("${name} ${surname}",
                    style: welcomePageText.copyWith(
                      fontSize: 20,
                    )),
              ],
            ),
          ),

          //Go to Profile Page
          ListTile(
            title: Text(
              'My Profile',
              style: blackText.copyWith(
                fontSize: 14.5,
              ),
            ),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);
              List args1 = [user_id , name, surname, curr_user_email, profilePicture];

              // Navigate to the profile page
              Navigator.pushNamed(context, '/profile', arguments: args1);
            },
          ),

          ListTile(
              title: Text(
                'Garden Collaboration Requests',
                style: blackText.copyWith(
                  fontSize: 14.5,
                ),
              ),
              onTap: () {
                // Close the drawer
                Navigator.pop(context);
                //Create the arguments that we will pass to the next page
                //The arguments we pass to a new page can be any object
                ProfileDetailsArguments args=ProfileDetailsArguments(user_id, password, gardens, name, surname, curr_user_email, profilePicture);
                Navigator.pushNamed(context, '/invitations', arguments: args);
              }),
          ListTile(
            title: Text(
              'Food Atlas',
              style: blackText.copyWith(
                fontSize: 14.5,
              ),
            ),
            onTap: () async {
              // Close the drawer
              var conn= await MySqlConnection.connect(settings);
              var results2=await conn.query(
                  "SELECT*FROM ATLAS ORDER BY FOOD ASC"
              );
              List resultList=results2.toList();
              Navigator.pop(context);
              Navigator.pushNamed(context, '/atlasPage',arguments: resultList);

            },
          ),

          ListTile(
            title: Text(
              'Change Password',
              style: blackText.copyWith(
                fontSize: 14.5,
              ),
            ),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);
              List args=[curr_user_email,password];
              Navigator.pushNamed(context, '/changePassword', arguments: args);

            },
          ),
          ListTile(
            title: Text(
              'Log Out',
              style: blackText.copyWith(
                fontSize: 14.5,
              ),
            ),
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
    ModalRoute.of(context)!.settings.arguments as ProfileDetailsArguments;
    //Extract the user's ID and gardens from the arguments
    int user_id = arguments.userID;
    String name = arguments.name;
    String surname = arguments.surname;
    String curr_user_email = arguments.email;
    List gardens = arguments.gardens;
    String password = arguments.password;

    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      appBar: AppBar(
        //This is the title at the top of the screen
        title: const Text('My Gardens', style: welcomePageText),
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
              ProfileDetailsArguments args =
              ProfileDetailsArguments(user_id, password,gardens,name,surname,curr_user_email, password);
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
            child: UserGardensList(user_id, gardens),
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
                  var results2=await conn.query(
                      "SELECT * FROM ATLAS"
                  );
                  List atlas=results2.toList();
                  //Convert the results of the database query to a list
                  List foodList = results.toList();
                  //Create the arguments that we will pass to the next page
                  gardenInfoArgs args = gardenInfoArgs(
                      userID,
                      gardens[index]["LOG_ID"],
                      foodList,
                      gardens[index]["LOG_NAME"],
                      atlas);
                  //Navigate to the add garden screen using a named route.
                  Navigator.pushNamed(context, '/foodPage',
                      arguments: args);
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
                  Navigator.pushNamed(context, '/analyticsPage',
                      arguments: args);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}