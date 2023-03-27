import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import 'ConnectionSettings.dart';
import 'CreateAccountPage.dart';
import '../styles.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

Widget buildEmail() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: <Widget>[
      const Text(
        'Username',
        style: loginPageText
      ),
      const SizedBox(height: 2),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: primaryColour.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        height: 45,
          child: const TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
          ),
      )
    ],
  );
}

Widget buildPassword() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const SizedBox(height: 10),

      const Text(
        'Password',
        style: loginPageText
      ),

      const SizedBox(height: 2),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: primaryColour.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
            
        ),
        height: 45,

        child: const TextField(
          obscureText: true,
          style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
        ),
      )
    ],
  );
}

Widget buildLoginButton() {
  return Column(
    children: <Widget>[
      const SizedBox(height: 50),

      OutlinedButton(
        onPressed: () {}, 

        style: OutlinedButton.styleFrom(
          side: BorderSide(
          color: primaryColour,
          width: 1
          ),
        ),

        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 120
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Log in',
                          style: loginPageText.copyWith(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        const SizedBox(height: 50),

                        buildEmail(),
                        buildPassword(),
                        buildLoginButton()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
      )
    );
  }

}