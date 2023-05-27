import 'package:dartfactory/Arguments/OpenDataBase.dart';
import 'package:dartfactory/views/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/src/single_connection.dart';

import '../Arguments/Invitation.dart';
import '../Arguments/ProfileDetailsArguments.dart';
import '../ConnectionSettings.dart';
import '../styles.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

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
    String profilePicture = arguments.profilePicture;
    List gardens = arguments.gardens;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invitations'),
        backgroundColor: primaryColour,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), 
          onPressed: () async {
            var conn = await MySqlConnection.connect(settings);
            //Request the users gardens from the database
            var gardenResults = await conn
                .query('select * from LOG where USER_ID = ?', [user_id]);
            //Convert the results of the database query to a list
            List gardenResultsList = gardenResults.toList();
            //Create the arguments that we will pass to the next page
            ProfileDetailsArguments args=ProfileDetailsArguments(user_id, gardenResultsList, name, surname, curr_user_email, profilePicture);
            Navigator.pushNamed(context, '/userGardens', arguments: args);
          },
        ),
      ),
      body: InvitationsScreen2(user_id, name, surname, curr_user_email, gardens),
      );
  }
}

class InvitationsScreen2 extends StatefulWidget {

  //We have to initialise the variable
  int user_id = 0;
  String name = "";
  String surname = "";
  String curr_user_email = "";
  List gardens = [];

  //Constructor
  InvitationsScreen2(int passedUserID, String passedName, String passedSurname, String passedEmail, List passedGardens, {super.key}) {
    user_id = passedUserID;
    name = passedName;
    surname = passedSurname;
    gardens = passedGardens;
    curr_user_email = passedEmail;
  }

  @override
  _InvitationsScreenState createState() => _InvitationsScreenState(user_id, name, surname, curr_user_email, gardens);
}

class _InvitationsScreenState extends State<InvitationsScreen2> {
  List<Invitation> invitations = []; // Assuming Invitation is the model class
  bool isLoading=true;
  bool isEmpty = false;

  //We have to initialise the variable
  int user_id = 0;
  String name = "";
  String surname = "";
  String curr_user_email = "";
  List gardens = [];

  //Constructor
  _InvitationsScreenState(int passedUserID, String passedName, String passedSurname, String passedEmail, List passedGardens) {
    user_id = passedUserID;
    name = passedName;
    surname = passedSurname;
    gardens = passedGardens;
    curr_user_email = passedEmail;
  }


  void initState() {
    super.initState();
    fetchInvitations(curr_user_email);
  }

  Future<void> fetchInvitations(String email) async {
    setState(() { isLoading = true; });
    var conn = await MySqlConnection.connect(settings);
    var result = await conn.query(
      'SELECT * FROM INVITATIONS WHERE (RECIPIENT_EMAIL, STATUS) = (?, ?)',
      [email, "UNSEEN"],
    );

    var rows = result.toList();
    Set<Invitation> fetchedInvitations = {};
    for (var row in rows!) {
      Invitation invitation = Invitation(row[0], row[2], row[3]);
      fetchedInvitations.add(invitation);
    }

    setState(() {
      invitations = fetchedInvitations.toList();
      isLoading = false;
      if(invitations.isEmpty){
        isEmpty = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You do not have any invitations",
              style: TextStyle(
                fontSize: 18, // Adjust the font size here
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            // Text(
            //   "\u{1F600}", // Smiling emoji Unicode representation
            //   style: TextStyle(
            //     fontSize: 24, // Adjust the font size here
            //   ),
            // ),
          ],
        ),
      )

      :isLoading
          ? Center(child: CircularProgressIndicator())
      :ListView.builder(
        itemCount: invitations.length,
        itemBuilder: (context, index) {
          final invitation = invitations[index];
          return Card(
            child: ListTile(
              title: Text(invitation.senderName),
              subtitle: Text(invitation.gardenName),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      acceptInvitation(invitation, curr_user_email, user_id);
                       // Function to accept the invitation
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      declineInvitation(invitation, curr_user_email, user_id); // Function to decline the invitation
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void acceptInvitation(Invitation invitation, String email, int id) async{
    var conn = await MySqlConnection.connect(settings);
    conn.query(
      'CALL ACCEPT_INVITATION(?,?,?,?)',[id, email, invitation.gardenId, invitation.gardenName]
    );
    fetchInvitations(email);
  }

  void declineInvitation(Invitation invitation, String email, int id) async {
    var conn = await MySqlConnection.connect(settings);
    try{conn.query(
        'CALL DECLINE_INVITATION(?,?,?)',[id,email,invitation.gardenId]
    );
    fetchInvitations(email);
  }
  catch(e){
    print(e);
    }
  }
}
