import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import '../styles.dart';
import 'HomePage.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      backgroundColor: primaryColour,
      //The body is filled with the CreateAccountForm class below
      body:
          const CreateAccountForm(), //use form inside page so text thingies work
    );
  }
}

//This is our form widget
class CreateAccountForm extends StatefulWidget {
  const CreateAccountForm({super.key});

  @override
  State<CreateAccountForm> createState() => _CreateAccountFormState();
}

//This class holds data related to the form
class _CreateAccountFormState extends State<CreateAccountForm> {
  //These variables store the first name, last name, email, and password entered by the user
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Create a global key that uniquely identifies the Form widget
  //and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  // Everything below determines how the page is displayed
  Widget build(BuildContext context) {
    //we are using a form to allow for input validation
    return Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 75),
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Text('Create Account',
                        style: signUpPageText.copyWith(
                            fontSize: 35, fontWeight: FontWeight.bold))),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('already have an account?',
                        style: signUpPageText.copyWith(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Log In Here',
                          style: loginPageText.copyWith(
                            fontSize: 14,
                            color: tertiaryColour,
                          ),
                          textAlign: TextAlign.right,
                        ))
                  ],
                ),

                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5)),
                      labelStyle: signUpPageText,
                      labelText: 'First Name',
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
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5)),
                      labelStyle: signUpPageText,
                      labelText: 'Last Name',
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

                //email address
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5)),
                      labelStyle: signUpPageText,
                      labelText: 'Email Address',
                    ),

                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      } else if (!EmailValidator.validate(value.trim())) {
                        return 'Please enter valid email';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),

                //password
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5)),
                      labelStyle: signUpPageText,
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
                    height: 90,
                    padding: const EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColour,
                        ),
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            //If the form is valid
                            //Establish connection with the database
                            var conn = await MySqlConnection.connect(
                                ConnectionSettings(
                                    host: 'db4free.net',
                                    port: 3306,
                                    user: 'hardcoded',
                                    password: '5Scrummies@SD',
                                    db: 'harvestapp'));
                            var fName = firstNameController.text;
                            var lName = lastNameController.text;
                            var email = emailController.text;
                            var password = passwordController.text;
                            //Add the new user to the database (the USER table in the database needs to auto increment user_id for this command to work)
                            await conn.query(
                                'insert into USERS (user_fname, user_lname, user_email, user_password) values (?, ?, ?, ?)',
                                [fName, lName, email, password]);
                            //after inserting, navigate back to login page so that the user can login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          }
                          //Trying to navigate back to the login page
                          else if (_formKey.currentState!.validate()) {}
                        },
                        child: Text('SIGN UP',
                            style: signUpPageText.copyWith(
                              fontSize: 25,
                              color: primaryColour,
                            )))),
              ],
            )));
  }
}
