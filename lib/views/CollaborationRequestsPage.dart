import 'package:dartfactory/Arguments/OpenDataBase.dart';
import 'package:dartfactory/views/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/src/single_connection.dart';

import '../Arguments/Invitation.dart';
import '../ConnectionSettings.dart';
import '../styles.dart';

class InvitationsScreen extends StatefulWidget {
  @override
  final List list;
  InvitationsScreen({required this.list});
  _InvitationsScreenState createState() => _InvitationsScreenState();


}

class _InvitationsScreenState extends State<InvitationsScreen> {
  List<Invitation> invitations = []; // Assuming Invitation is the model class
  bool isLoading=true;


  void initState() {
    super.initState();
    fetchInvitations(widget.list.elementAt(0));
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
    });
  }

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments

    return Scaffold(
      appBar: AppBar(
        title: Text('Invitations'),
      ),
      body: invitations.isEmpty
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
            Text(
              "\u{1F600}", // Smiling emoji Unicode representation
              style: TextStyle(
                fontSize: 24, // Adjust the font size here
              ),
            ),
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
                      acceptInvitation(invitation);
                      print(gardens); // Function to accept the invitation
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      declineInvitation(invitation); // Function to decline the invitation
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

  void acceptInvitation(Invitation invitation) async{
    var conn = await MySqlConnection.connect(settings);
    conn.query(
      'CALL ACCEPT_INVITATION(?,?,?,?)',[widget.list.elementAt(1),widget.list.elementAt(2),invitation.gardenId,invitation.gardenName]
    );
    fetchInvitations(widget.list.elementAt(0));
  }

  void declineInvitation(Invitation invitation) async {
    var conn = await MySqlConnection.connect(settings);
    try{conn.query(
        'CALL DECLINE_INVITATION(?,?,?)',[widget.list.elementAt(1),widget.list.elementAt(2),invitation.gardenId]
    );
    fetchInvitations(widget.list.elementAt(0));
  }
  catch(e){
    print(e);
    }
  }
}
