import 'package:dartfactory/Arguments/Invite.dart';
import 'package:dartfactory/Arguments/inviteHelper.dart';
import 'package:dartfactory/styles.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mysql1/mysql1.dart';

import '../ConnectionSettings.dart';


class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
    ModalRoute.of(context)!.settings.arguments as InviteHelper;
    //Extract the garden's info from the arguments
    int userID = arguments.userID;
    String gardenName = arguments.gardenName;
    List users = arguments.users;
    int gardenId=arguments.gardenId;

    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      //This is the title at the top of the screen
      appBar: AppBar(
        title: const Text('Available Users', style: welcomePageText,),
        backgroundColor: primaryColour,
      ),
      //The body is filled with the AddGardenForm class below
      body: UserList(userID, gardenName ,gardenId, users),
    );
  }
}

class UserList extends StatefulWidget {
  //We have to initialise the variable
  int userID = 0;
  String gardenName = "";
  List users = [];
  int gardenId=0;

  //Constructor
  UserList(int passedUserID, String passedGardenID,int gardenIDnum, List passedFood, {super.key}) {
    userID = passedUserID;
    gardenName = passedGardenID;
    users = passedFood;
    gardenId=gardenIDnum;
  }

  @override
  State<UserList> createState() => _UserListState(userID, gardenName,gardenId, users);
}

class _UserListState extends State<UserList> {
  //We have to initialise the variable
  int userID = 0;
  String gardenName = "";
  List user = [];
  int gardenId=0;
  //Constructor
  _UserListState(int passedUserID, String passedGardenID,int gardenIDnum, List passedUsers) {
    userID = passedUserID;
    gardenName = passedGardenID;
    user = passedUsers;
    gardenId=gardenIDnum;
  }

  TextEditingController editingController = TextEditingController();

  final availableusers = <String>{};
  final useremails=<String>[];
  var items = <String>[];

  @override
  void initState() {
    for(int i = 0; i < user.length; i++){
      //Add every user  in the database to duplicateItems
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
                  //What happens when the user is tapped
                  onTap: () async {
                    Invite invite=Invite(userID, useremails[index], gardenName,gardenId);
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
                                var conn = await MySqlConnection.connect(settings);
                                var result=await conn.query(
                                  "SELECT*FROM INVITATIONS WHERE (RECIPIENT_EMAIL,S_GARDEN_NAME,S_GARDEN_ID,STATUS)=(?,?,?,?)",
                                  [invite.r_email,invite.sender_log_name,invite.sender_logid,"UNSEEN"]
                                );
                                List results=result.toList();
                                if(results.isEmpty){
                                  await invite.sendInvite();
                                }
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

