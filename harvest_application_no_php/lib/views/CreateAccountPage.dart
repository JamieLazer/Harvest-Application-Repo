import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'HomePage.dart';


class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      //This is the title at the top of the screen
      appBar: AppBar(
        title: const Text('Harvest'),
      ),
      //The body is filled with the CreateAccountForm class below
      body: const CreateAccountForm(),
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
class _CreateAccountFormState extends State<CreateAccountForm>{

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: 'db4free.net',
        port: 3306,
        user: 'hardcoded',
        password: '5Scrummies@SD',
        db: 'harvestapp');
    return await MySqlConnection.connect(settings);
  }

  Future<bool> checkEmailExists(String email) async {
    var conn = await getConnection();
    var results = await conn.query(
        'SELECT COUNT(*) AS count FROM USERS WHERE user_email = ?',
        [email]);
    var count = results.first['count'];
    await conn.close();
    return count > 0;
  }

  Future<void> signUp(String name, String surname, String email, String password) async {
    try {
      var emailExists = await checkEmailExists(email);
      if (emailExists) {
        Fluttertoast.showToast(msg: 'Email already exists');
        return;
      }
      var conn = await getConnection();
      await conn.query(
          'INSERT INTO USERS (user_fname, user_lname, user_email, user_password) VALUES (?, ?, ?, ?)',
          [name, surname, email, password]);
      await conn.close();
      Fluttertoast.showToast(msg: 'Sign-up successful');
      //Navigate to the home page using a named route
      Navigator.pushNamed(context, '/homePage');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

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
    return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
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
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
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
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email Address',
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
              padding: const EdgeInsets.all(10),
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
                height: 60,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                    child: const Text('Sign up', style: TextStyle(fontSize: 20)),
                    onPressed: () async {
                      //Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        //If the form is valid, execute the signUp method
                        var fName = firstNameController.text;
                        var lName = lastNameController.text;
                        var email = emailController.text;
                        var password = passwordController.text;

                        await signUp(fName, lName, email, password);
                      }
                    }
                )
            ),
          ],
        ));
  }
}
