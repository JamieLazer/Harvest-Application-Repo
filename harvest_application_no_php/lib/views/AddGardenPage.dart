import 'dart:async';

import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';

import '../ConnectionSettings.dart';
import '../UserInfoArguments.dart';

class AddGardenPage extends StatelessWidget {
  const AddGardenPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments = ModalRoute.of(context)!.settings.arguments as UserInfoArguments;
    //Extract the user's gardens from the arguments
    List gardens = arguments.gardens;
    //Extract the user ID from the arguments
    int userID = arguments.userID;


    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      //This is the title at the top of the screen
      appBar: AppBar(
        title: const Text('Harvest'),
      ),
      //The body is filled with the AddGardenForm class below
      body: AddGardenForm(userID, gardens),
    );
  }
}

//This is our form widget
class AddGardenForm extends StatefulWidget {
  //We have to initialise the variables
  int userID = 0;
  List gardens = [];

  //Constructor
  AddGardenForm(int passedUserID, List passedGardens, {super.key}) {
    this.userID = passedUserID;
    this.gardens = passedGardens;
  }

  @override
  State<AddGardenForm> createState() => _AddGardenFormState(userID, gardens);
}

//This class holds data related to the form
class _AddGardenFormState extends State<AddGardenForm>{
  //We have to initialise the variables
  int userID = 0;
  List gardens = [];

  //Constructor
  _AddGardenFormState(int passedUserID, List passedGardens) {
    this.userID = passedUserID;
    this.gardens = passedGardens;
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
    return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Add a Garden',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: gardenController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Garden Name',
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
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                    child: const Text('Add Garden', style: TextStyle(fontSize: 20)),
                    onPressed: () async {
                      //Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        //If the form is valid
                        //Establish connection with the database
                        var conn = await MySqlConnection.connect(settings);
                        String gardenName = gardenController.text;
                        //Add the garden to the LOG table in the database
                        await conn.query('CALL ADD_GARDEN(?, ?)', [userID, gardenName]);

                        //Request the updated users gardens from the database
                        var updatedGardens = await conn.query('select * from LOG where USER_ID = ?', [userID]);
                        //Convert the results of the database query to a list
                        List updatedGardensList = updatedGardens.toList();

                        //Create the arguments that we will pass to the next page
                        //The arguments we pass to a new page can be any object
                        UserInfoArguments args = UserInfoArguments(userID, updatedGardensList);

                        //Navigate back to the user garden screen using a named route and pass the new page the arguments
                        Navigator.pushNamed(context, '/userGardens', arguments: args);
                      }
                    }
                )
            ),
          ],
        ));
  }
}

