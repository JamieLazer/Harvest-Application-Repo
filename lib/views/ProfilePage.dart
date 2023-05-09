import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../styles.dart';
import 'WelcomePage.dart';
import '../Arguments/UserInfoArguments.dart';
import '../ConnectionSettings.dart';

List userNames = [];
List gardens = [];

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
    ModalRoute.of(context)!.settings.arguments as UserInfoArguments;
    //Extract the user's ID and gardens from the arguments
    int userID = arguments.userID;
    List userNames = [];

    return FutureBuilder(
      future: MySqlConnection.connect(settings).then((conn) => conn.query(
          'select user_fname, user_lname from USERS where user_id = ?;',
          [userID])),
      builder: (context, AsyncSnapshot<Results> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Show error message
            return const Center(child: Text('An error occurred.'));
          } else {
            //Convert the results of the database query to a list
            userNames = snapshot.data!.toList();
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
                        const CircleAvatar(
                          radius: 50,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${userNames[0]["user_fname"]} ${userNames[0]["user_lname"]}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('Gardens'),
                    onTap: () {
                      // Close the drawer
                      Navigator.pop(context);

                      //Return to usergardens

                    },
                  ),
                  ListTile(
                    title: const Text('Change Password'),
                    onTap: () {
                      // Close the drawer
                      Navigator.pop(context);

                      // Navigate to the change password page
                      Navigator.pushNamed(context, '/changePassword');
                    },
                  ),
                  ListTile(
                    title: const Text('Garden Collaboration Requests'),
                    onTap: () {
                      // Close the drawer
                      Navigator.pop(context);

                      // Navigate to the collaboration requests page
                      Navigator.pushNamed(
                          context, '/collaborationRequests');
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
                        MaterialPageRoute(
                            builder: (context) => const WelcomePage()),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        } else {
          // Show loading spinner
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
   const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
    ModalRoute.of(context)!.settings.arguments as UserInfoArguments;
    //Extract the user's ID and gardens from the arguments
    int userID = arguments.userID;
    gardens = arguments.gardens;

    return FutureBuilder<Results>(
      future: MySqlConnection.connect(settings).then((conn) =>
          conn.query('select user_fname, user_lname from USERS where user_id = ?;',
              [userID])),
      builder: (context, AsyncSnapshot<Results> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Show error message
            return const Center(child: Text('An error occurred.'));
          } else {
            //Convert the results of the database query to a list
            List userNames = snapshot.data!.toList();

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text(
                    'My Profile',
                    style: welcomePageText,
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
                ),
                drawer: const SideMenu(),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${userNames[0]} ${userNames[1]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
        // Return null when connectionState is not waiting or done
        return Container();
      },
    );
  }

}
