import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../styles.dart';
import 'WelcomePage.dart';
import '../Arguments/UserInfoArguments.dart';
import '../ConnectionSettings.dart';
import 'NewPasswordPage.dart';

List userNames = [];
List gardens = [];

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  //double tap message
  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text('Double Tap To Change Image', style: blackText.copyWith(fontSize: 15),),
        backgroundColor: Colors.grey[300],
      ),
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          title: const Text('My Profile',
          style: welcomePageText
          ),
          backgroundColor: primaryColour,
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //profile picture + gradient
            Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFF80A87A),
                      Color(0xFF5D977B),
                      Color(0xFF43847A),
                      Color(0xFF337074),
                      Color(0xFF2F5C69),
                      Color(0xFF2F4858),
                    ],
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.5),
                  child: GestureDetector(
                    onTap: () => _showToast(context),
                    onDoubleTap: () {
                      //change dp
                    },
                    //profile photo
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white10,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "name", 
                        style: blackText.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 14
                        ),
                        textAlign: TextAlign.left,
                      ),
            
                      SizedBox(height: 4,),

                      Text(
                        "Name Surname",
                        style: blackText.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.black54,
                          fontSize: 14
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(height: 12,),

                      Text(
                        "email",
                        style: blackText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 14
                          ),
                        ),

                      SizedBox(height: 4,),

                      Text(
                        "namesurname@yahoo.com",
                        style: blackText.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.black54,
                          fontSize: 14
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(height: 12,),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/changepassword');
                        },
                        child: Text(
                          'Change Password',
                          style: blackText.copyWith(
                            fontSize: 14,
                            color: secondaryColour,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      )
                    ]
                  ),
              ),
            ),
          ],
        ),
      );
  }
}
