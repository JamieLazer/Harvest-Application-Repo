import 'package:flutter/material.dart';
import '../styles.dart';
import 'WelcomePage.dart';
import '../Arguments/UserInfoArguments.dart';

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

              //Return to usergardens
              
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Scaffold(
        backgroundColor: Colors.white,
        
        appBar: AppBar(
          title: const Text('My Profile',
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
        ),
        drawer: SideMenu(),
      ),
    );
  }
}