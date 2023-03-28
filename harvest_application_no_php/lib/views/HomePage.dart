import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';

import '../ConnectionSettings.dart';
import 'CreateAccountPage.dart';
import '../styles.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

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
                  
                  return null;
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

Widget buildLoginButton(TextEditingController emailController, TextEditingController passwordController, GlobalKey<FormState> _formKey) {
  return Column(
    children: <Widget>[
      const SizedBox(height: 50),

      OutlinedButton(
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
  );
}

class _LoginPageState extends State<LoginPage> {
  //These variables store the email and password entered by the user
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Create a global key that uniquely identifies the Form widget
  //and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                  child: Form(
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
                      buildLoginButton(emailController, passwordController, _formKey)
      
                      ],
                    ),
                  ),
                )
              ),
            ),
      )
    );
  }

}