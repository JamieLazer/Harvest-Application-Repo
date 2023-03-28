import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';

import '../ConnectionSettings.dart';
import '../UserInfoArguments.dart';
import 'AddGardenPage.dart';
import 'CreateAccountPage.dart';
import 'UserGardensPage.dart';
import '../styles.dart';

Widget buildEmail(TextEditingController emailController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: <Widget>[
      
      //the text box
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: primaryColour.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
        ),

        height: 60, //container height

          child: Material(
            color: Colors.transparent,
            child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,

            style: const TextStyle(
              color: Colors.black87,
              fontSize: 17,
            ),

            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              labelText: "Username",
              labelStyle: loginPageText
            ),

            // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  
                   else if (!EmailValidator.validate(value.trim())) {
                  return 'Please enter valid email';
                } else {
                  return null;
                }
                },
            ),
          )
      )
    ],
  );
}

Widget buildPassword(TextEditingController passwordController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const SizedBox(height: 10),

      //password box
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: primaryColour.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
            
        ),
        height: 60,

        child: Material(
          color: Colors.transparent,
          child: TextFormField(
          obscureText: true,
          controller: passwordController,

          style: const TextStyle(
              color: Colors.black87,
              fontSize: 17,
          ),

          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              labelText: "Password",
              labelStyle: loginPageText
          ),

          // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
          ),
        )
      )
    ],
  );
}

// Widget buildLoginButton(TextEditingController emailController, TextEditingController passwordController, GlobalKey<FormState> _formKey, bool _isLoading) {
//   return 
// }

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/createAccount': (context) => const CreateAccountPage(),
        '/userGardens': (context) => const UserGardensPage(),
        '/addGarden': (context) => const AddGardenPage(),
        '/homePage': (context) => LoginPage(),
        },
      
      home: Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 120
                  ),

                  child: LoginForm(),
                )
              ),
            ),
      )
    )
    );
  }

}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

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
        
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Log in',
              style: loginPageText.copyWith(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 50),

          buildEmail(emailController),
          buildPassword(passwordController),
          //buildLoginButton

          Column(
            children: <Widget>[
              const SizedBox(height: 50),

              OutlinedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    //If the form is valid
                    setState(() {
                      _isLoading = true;
                    });

                    bool loginSuccessful =
                        await login(emailController.text, passwordController.text);

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
                        } 
                        
                        else {
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
                },

                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                  color: primaryColour,
                  width: 1.5,
                  ),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),

                            child: Center(
                              child: Text (
                                'log in',
                                style: loginPageText.copyWith(
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          )
                        ],
                      )

                    )
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: <Widget>[
                  Text(
                    'new to Harvest?',
                     style: loginPageText.copyWith(
                      fontSize: 14,
                       color: Colors.black,
                      fontStyle: FontStyle.italic,
                    )
                   ),

                  TextButton(
                    onPressed: () {},

                    child: Text(
                      'Sign Up Here',
                      style: loginPageText.copyWith(
                        fontSize: 14,
                        color: secondaryColour,
                      ),
                      textAlign: TextAlign.right,
                    )
                   )
                ],
              ),
            ],
          )

        ],
      ),
    );
  }
}