import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../styles.dart';
import 'WelcomePage.dart';
import '../Arguments/UserInfoArguments.dart';
import '../ConnectionSettings.dart';

List userNames = [];
List gardens = [];

class UserDatabase {
  static final UserDatabase _singleton = UserDatabase._internal();
  late MySqlConnection _conn;
  late Map<Object?, List<dynamic>> _userNamesCache;

  factory UserDatabase() {
    return _singleton;
  }

  UserDatabase._internal() {
    _userNamesCache = {};
    MySqlConnection.connect(settings).then((conn) => _conn = conn);
  }

  Future<List<dynamic>> getUserNames(Object? userID) async {
    if (_userNamesCache.containsKey(userID)) {
      // Use cached value
      return _userNamesCache[userID]!;
    } else {
      // Fetch from database and cache the result
      final result = await _conn.query(
          'select user_fname, user_lname from USERS where user_id = ?;', [userID]);
      final userNames = result.toList();
      _userNamesCache[userID] = userNames;
      return userNames;
    }
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
        ModalRoute.of(context)!.settings.arguments;
    //Extract the user's ID and gardens from the arguments
    Object? userID = arguments;
    final userDB = UserDatabase();

    return FutureBuilder(
      future: userDB.getUserNames(userID),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Show error message
            return const Center(child: Text('An error occurred.'));
          } else {
            //Convert the results of the database query to a list
            final userNames = snapshot.data!;
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
                      Navigator.pop(context);
                      Navigator.pop(context);
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
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    Object? userID = arguments;
    final userDB = UserDatabase();

    return FutureBuilder(
      future: userDB.getUserNames(userID),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred.'));
          } else {
            final userNames = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'My Profile',
                  style: welcomePageText,
                ),
                backgroundColor: primaryColour,
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
                      "${userNames[0]["user_fname"]} ${userNames[0]["user_lname"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

