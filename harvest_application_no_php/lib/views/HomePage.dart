import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import '../ConnectionSettings.dart';
import '../UserInfoArguments.dart';
import 'AddGardenPage.dart';
import 'CreateAccountPage.dart';
import 'UserGardensPage.dart';


//A stateless widget never changes
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //MaterialApp is the starting point of your app, it tells Flutter that you are going to use Material components and follow material design in your app.
    //We only have one MaterialApp in the project so that we only have one navigator to allow for pushing and popping of routes
    //Any named routes needed in the app must be added to this MaterialApp's routes
    return MaterialApp(
      //Scaffold is used under MaterialApp, it gives you many basic functionalities, like AppBar, BottomNavigationBar, Drawer, FloatingActionButton etc.
      home: Scaffold(
        //This is the title at the top of the screen
        appBar: AppBar(title: const Text('Harvest')),
        //The body is filled with the LoginWidget class below
        body: const LoginForm(),
      ),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      //Add all of the routes for the app
      routes: {
        //When navigating to the "/createAccount" route, open the CreateAccountPage.
        '/createAccount': (context) => const CreateAccountPage(),
        '/userGardens': (context) => const UserGardensPage(),
        '/addGarden': (context) => const AddGardenPage(),
        '/homePage': (context) => const HomePage(),
      },

    );
  }
}

//If a widget can change when a user interacts with it for example, it is stateful
//This is our form widget
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  //StatefulWidget instances themselves are immutable and can store their mutable state in separate State objects that are created by the createState method,
  @override
  State<LoginForm> createState() => _LoginFormState();
}

//This class holds data related to the form
class _LoginFormState extends State<LoginForm> {

  bool _isLoading = false;

  // This async method connects To the remote mySQL database.
  Future<MySqlConnection> getConnection() async {
    return await MySqlConnection.connect(settings);
  }

  //
  Future<bool> login(String email, String password) async {
    // Establish a connection to the database
    final conn = await getConnection();
    try {
      // Execute a query to check if the user's email and password match
      final results = await conn.query(
          'SELECT * FROM USERS WHERE user_email = ? AND user_password = ?',
          [email, password]);

      // If the query returns exactly one row, the login was successful
      if (results.length == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any exceptions that occur during the query execution
      print('Error during login: $e');
      return false;
    } finally {
      // Close the connection when done
      await conn.close();
    }
  }

  //These variables store the email and password entered by the user
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Create a global key that uniquely identifies the Form widget
  //and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Image.asset('assets/images/Logo.jpg', fit: BoxFit.cover),),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in to your account',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  else if(!EmailValidator.validate(value.trim())){
                    return 'Please enter valid email';
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
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
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                    child: const Text('Login', style: TextStyle(fontSize: 20)),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        //If the form is valid
                        setState(() {
                          _isLoading = true;
                        });

                        // The program waits for login() to return a result before continuing.
                        bool loginSuccessful = await login(emailController.text, passwordController.text);

                        setState(() {
                          _isLoading = false;
                        });

                        // If the login is successful move to the next view.
                        if (loginSuccessful) {
                          //The following query is necessary to create the arguments needed for the next view
                          var conn = await MySqlConnection.connect(settings);
                          var email = emailController.text;
                          var password = passwordController.text;
                          //Make a request for the user with the specified email and password
                          var results = await conn.query('select * from USERS where user_email = ? and user_password = ?', [email, password]);
                          //Convert the results of the database query to a list
                          List resultsList = results.elementAt(0).toList();
                          //Request the users gardens from the database
                          var gardenResults = await conn.query('select * from LOG where USER_ID = ?', [resultsList[0]]);
                          //Convert the results of the database query to a list
                          List gardenResultsList = gardenResults.toList();

                          //Create the arguments that we will pass to the next page
                          //The arguments we pass to a new page can be any object
                          UserInfoArguments args = UserInfoArguments(resultsList[0], gardenResultsList);

                          //Navigate to the user garden screen using a named route and pass the new page the arguments
                          Navigator.pushNamed(context, '/userGardens', arguments: args);

                          //If the login is not successful, display an error message through an AlertDialog.
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Login failed"),
                                content: Text("Please try again."),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    }
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account?"),
                TextButton(
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      // Navigate to the create account screen using a named route.
                      Navigator.pushNamed(context, '/createAccount');
                    }
                )
              ],
            ),
          ],
        ));
  }
}