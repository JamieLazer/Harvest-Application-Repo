import 'package:flutter/material.dart';

import '../styles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColour,

       child: Padding(
          padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,

            children: <Widget>[
              //welcome heading
              Text(
                'Welcome to Harvest!',  
                style: welcomePageText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              //welcome text
              Text(
                'Track your harvest yields, view previous yields and share gardens with other users',  
                style: welcomePageText.copyWith(
                  fontSize: 16,
                  // fontStyle: FontStyle.italic
                )
              ),

              const Padding(
                padding: EdgeInsets.only(top:30)
                ),

              //get started button
              Center(
                child: OutlinedButton(
                  onPressed: () {},

                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: tertiaryColour,
                      width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))
                  ),
                  
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      'Get Started!',
                      style: welcomePageText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: tertiaryColour,
                      )
                    ),
                  ),
                ),
              )
            ]
          ),
        ),
    );
  }

}