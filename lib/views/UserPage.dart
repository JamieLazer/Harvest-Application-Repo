import 'package:dartfactory/Arguments/Invite.dart';
import 'package:dartfactory/Arguments/inviteHelper.dart';
import 'package:dartfactory/styles.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
    ModalRoute.of(context)!.settings.arguments as InviteHelper;
    //Extract the garden's info from the arguments
    int userID = arguments.userID;
    int gardenID = arguments.gardenID;
    List users = arguments.users;

    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      //This is the title at the top of the screen
      appBar: AppBar(
        title: const Text('Available Users', style: welcomePageText,),
        backgroundColor: primaryColour,
      ),
      //The body is filled with the AddGardenForm class below
      body: UserList(userID, gardenID, users),
    );
  }
}

class UserList extends StatefulWidget {
  //We have to initialise the variable
  int userID = 0;
  int gardenID = 0;
  List users = [];

  //Constructor
  UserList(int passedUserID, int passedGardenID, List passedFood, {super.key}) {
    userID = passedUserID;
    gardenID = passedGardenID;
    users = passedFood;
  }

  @override
  State<UserList> createState() => _UserListState(userID, gardenID, users);
}

class _UserListState extends State<UserList> {
  //We have to initialise the variable
  int userID = 0;
  int gardenID = 0;
  List user = [];

  //Constructor
  _UserListState(int passedUserID, int passedGardenID, List passedUsers) {
    userID = passedUserID;
    gardenID = passedGardenID;
    user = passedUsers;
  }

  TextEditingController editingController = TextEditingController();

  final availableusers = <String>{};
  final useremails=<String>[];
  var items = <String>[];

  @override
  void initState() {
    for(int i = 0; i < user.length; i++){
      //Add every food item in the database to duplicateItems
      String name=user[i]["user_fname"];
      String surname=user[i]["user_lname"];
      String email=user[i]["user_email"];
      useremails.add(email);
      availableusers.add("${name} ${surname}");
    }
    //Sort the list alphabetically

    //Create a copy of duplicateItems
    for(int i = 0; i < availableusers.length; i++){
      items.add(availableusers.elementAt(i));
    }
    super.initState();
  }

  //This method shortens the list of food based on what a user types into the search
  void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];
    for(int i = 0; i < availableusers.length; i++){
      dummySearchList.add(availableusers.elementAt(i));
    }
    if(query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      query = query.toLowerCase();
      for (var item in dummySearchList) {
        String itemCopy = item.toLowerCase();
        if(itemCopy.startsWith(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        items.clear();
        for(int i = 0; i < dummyListData.length; i++){
          items.add(dummyListData[i]);
        }
      });
      return;
    } else {
      setState(() {
        items.clear();
        for(int i = 0; i < availableusers.length; i++){
          items.add(availableusers.elementAt(i));
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration:  InputDecoration(
                  hintText: "Search Users",
                  hintStyle: secondaryColourText.copyWith(
                      color: Colors.black54
                  ),
                  prefixIcon: Icon(Icons.search, color: secondaryColour,),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(
                        color: secondaryColour,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(
                        color: secondaryColour,
                      )
                  )

              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index], style: blackText.copyWith(
                      fontSize: 16
                  ),),
                  //What happens when the food is tapped
                  onTap: () async {
                    Invite invite=Invite(userID, useremails[index], gardenID);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Invite'),
                          content: Text('Send invite to ${items[index]} to share the garden'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Confirm'),
                              onPressed: () async{
                                await invite.sendInvite();
                                Navigator.of(context).pop();

                              },
                            ),
                            TextButton(child: Text("Cancel"),
                              onPressed:(){
                              Navigator.of(context).pop();
                              } ,)
                          ],
                        );
                      },
                    );

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

