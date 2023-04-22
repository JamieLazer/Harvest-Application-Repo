import 'package:dartfactory/styles.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';
import '../Arguments/GardenInfoArguments.dart';
import '../Arguments/LogFoodArguments.dart';
import '../ConnectionSettings.dart';

class AddFoodPage extends StatelessWidget {
  const AddFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
        ModalRoute.of(context)!.settings.arguments as LogFoodArguments;
    //Extract the info from the arguments
    int userID = arguments.userID;
    int gardenID = arguments.gardenID;
    List foodList = arguments.foodList;
    String foodName = arguments.foodName;

    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      //This is the title at the top of the screen
      appBar: AppBar(
        title: const Text('Yield', style: welcomePageText,),      
        backgroundColor: primaryColour,
      ),
      //The body is filled with the AddGardenForm class below
      body: AddFoodForm(userID, gardenID, foodList, foodName),
    );
  }
}

//This is our form widget
class AddFoodForm extends StatefulWidget {
  //We have to initialise the variables
    int userID = 0;
    int gardenID = 0;
    List foodList = [];
    String foodName = "";

  //Constructor
  AddFoodForm(int passedUserID, int passedGardenID, List passedFoodList, String passedFoodName, {super.key}) {
    userID = passedUserID;
    gardenID = passedGardenID;
    foodList = passedFoodList;
    foodName = passedFoodName;
  }

  @override
  State<AddFoodForm> createState() => _AddFoodFormState(userID, gardenID, foodList, foodName);
}

//This class holds data related to the form
class _AddFoodFormState extends State<AddFoodForm> {
  //We have to initialise the variables
    int userID = 0;
    int gardenID = 0;
    List foodList = [];
    String foodName = "";

  //Constructor
  _AddFoodFormState(int passedUserID, int passedGardenID, List passedFoodList, String passedFoodName) {
    userID = passedUserID;
    gardenID = passedGardenID;
    foodList = passedFoodList;
    foodName = passedFoodName;
  }

  //This variable stores the weight of the harvest
  TextEditingController weightController = TextEditingController();

  //Create a global key that uniquely identifies the Form widget
  //and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  // Everything below determines how the page is displayed
  Widget build(BuildContext context) {
    //we are using a form to allow for input validation
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  'How many kilograms did you harvest?',
                  style: blackText.copyWith(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                controller: weightController,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    
                  ),
                  focusedBorder: UnderlineInputBorder(),
                  hintText: 'kg',
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColour,
                    ),
                    child: const Text('Add to Garden',
                        style: welcomePageText),
                    onPressed: () async {
                      //Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        //If the form is valid
                        //Establish connection with the database
                        var conn = await MySqlConnection.connect(settings);

                        //Request the log name
                        var gardenNameResult = await conn.query(
                            'select LOG_NAME from LOG where LOG_ID = ?', [gardenID]);
                        
                        //Convert the results of the database query to a list
                        List gardenNameResultList = gardenNameResult.toList();
                        
                        String gardenName = gardenNameResultList[0]["LOG_NAME"];

                        double weight = double.parse(weightController.text);

                        //Add the harvest to the YIELD table in the database
                        await conn.query(
                            'CALL LOGGER(?, ?, ?, ?)', [foodName, gardenName, weight, userID]);

                        //Request the updated food list for this garden from the database
                        var updatedFood = await conn.query(
                            'select * from YIELD where LOG_ID = ?', [gardenID]);
                        //Convert the results of the database query to a list
                        List updatedFoodList = updatedFood.toList();

                        //Create the arguments that we will pass to the next page
                        //The arguments we pass to a new page can be any object
                        GardenInfoArguments args = GardenInfoArguments(userID, gardenID, updatedFoodList);

                        //Navigate back to the user garden screen using a named route and pass the new page the arguments
                        Navigator.pushNamed(context, '/foodPage',arguments: args);
                      }
                    })),
          ],
        ),
      )
    );
  }
}
