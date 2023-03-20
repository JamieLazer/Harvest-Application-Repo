import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import 'ConnectionSettings.dart';
import 'CreateAccountPage.dart';

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
                  return null;
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
                      //Establish connection with the database
                      var conn = await MySqlConnection.connect(settings);
                      var email = emailController.text;
                      var password = passwordController.text;
                      //Make a request for the user with the specified email and password
                      var results = await conn.query('select * from USERS where user_email = ? and user_password = ?', [email, password]);
                      //If the result of the request is exactly one row, the login was successful
                      if(results.length == 1){
                        print('Sucessful login');
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