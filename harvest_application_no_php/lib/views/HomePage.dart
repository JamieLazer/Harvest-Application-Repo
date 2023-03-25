import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import 'ConnectionSettings.dart';
import 'CreateAccountPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //MaterialApp is the starting point of the app.
    return MaterialApp(
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
        '/homePage': (context) => const HomePage(),
      },
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
    var settings = new ConnectionSettings(
        host: 'db4free.net',
        port: 3306,
        user: 'hardcoded',
        password: '5Scrummies@SD',
        db: 'harvestapp');
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
                child: Image.asset('assets/images/Logo.jpg', fit: BoxFit.cover),
            ),
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
                    setState(() {
                      _isLoading = true;
                    });
                    
                    // The program or waits for login() to return a result before continuing.
                    bool loginSuccessful = await login(emailController.text, passwordController.text);

                    setState(() {
                      _isLoading = false;
                    });

                    // If the login is successful move to the next view. 
                    // Otherwise, display an error message through an AlertDialog.
                    if (loginSuccessful) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
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