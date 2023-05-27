import 'package:dartfactory/Arguments/ProfileDetailsArguments.dart';
import 'package:dartfactory/styles.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';
import '../ConnectionSettings.dart';
import '../Arguments/UserInfoArguments.dart';

class AddGardenPage extends StatelessWidget {
  const AddGardenPage({super.key});

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
      backgroundColor: Colors.white,
      //This is the title at the top of the screen
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: primaryColour, // Set the color of the back button
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      //The body is filled with the AddGardenForm class below
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Colors.white,
            
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
            height: MediaQuery.of(context).size.height / 2,
            color: primaryColour,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 400,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: AddGardenForm(user_id, gardens,name,surname,curr_user_email, password)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//This is our form widget
class AddGardenForm extends StatefulWidget {
  //We have to initialise the variables
  int userID = 0;
  List gardens = [];
  String name='';
  String surname='';
  String email='';
  String password='';

  //Constructor
  AddGardenForm(int passedUserID, List passedGardens,String passedName,String passedSurname,String passedEmail, String passedPassword, {super.key}) {
    userID = passedUserID;
    gardens = passedGardens;
    name=passedName;
    surname=passedSurname;
    email=passedEmail;
    password = passedPassword;
  }

  @override
  State<AddGardenForm> createState() => _AddGardenFormState(userID, gardens,name,surname,email, password);
}

//This class holds data related to the form
class _AddGardenFormState extends State<AddGardenForm> {
  //We have to initialise the variables
  int userID = 0;
  List gardens = [];
  String name="";
  String surname="";
  String email="";
  String password="";
  //Constructor
  _AddGardenFormState(int passedUserID, List passedGardens,String passedName,String passedSurname,String passedEmail, String passedPassword) {
    userID = passedUserID;
    gardens = passedGardens;
    name=passedName;
    password = passedPassword;

  }

  //This variable stores the name of the garden
  TextEditingController gardenController = TextEditingController();

  //Create a global key that uniquely identifies the Form widget
  //and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  // Everything below determines how the page is displayed
  Widget build(BuildContext context) {
    //we are using a form to allow for input validation
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Create a New Garden!',
                      style: blackText.copyWith(fontSize: 25),
                    )
                    ),

                    SizedBox(height: 60,),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: gardenController,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54
                        )
                      ),
                      focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54)),
                      errorBorder: UnderlineInputBorder(),
                      labelText: 'Garden Name',
                      labelStyle: loginPageText.copyWith(
                        fontSize: 14,
                        color: Colors.black54
                      )
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                    height: 60,
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tertiaryColour,
                        ),
                        child: Text('Add Garden',
                            style: secondaryColourText.copyWith(
                              fontSize: 16
                            ),
                            ),
                        onPressed: () async {
                          //Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            //If the form is valid
                            //Establish connection with the database
                            var conn = await MySqlConnection.connect(settings);
                            String gardenName = gardenController.text;
                            //Add the garden to the LOG table in the database
                            await conn.query(
                                'CALL ADD_GARDEN(?, ?)', [userID, gardenName]);

                            //Request the updated users gardens from the database
                            var updatedGardens = await conn.query(
                                'select * from LOG where USER_ID = ?',
                                [userID]);
                            //Convert the results of the database query to a list
                            List updatedGardensList = updatedGardens.toList();

                            //Create the arguments that we will pass to the next page
                            //The arguments we pass to a new page can be any object
                            ProfileDetailsArguments args=ProfileDetailsArguments(userID,updatedGardensList,name,surname, email, password);

                            //Navigate back to the user garden screen using a named route and pass the new page the arguments
                            Navigator.pushNamed(context, '/userGardens',
                                arguments: args);
                          }
                        })),
              ],
            ),
          )
          )
        );
  }
}
