import 'package:flutter/material.dart';
import '../styles.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  //These variables store the password entered by the user
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: secondaryColour),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "enter old password",
                    style: blackText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 2,
                  ),

                  Container(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: TextFormField(
                      obscureText: true,
                      controller: oldPasswordController,
                      decoration:  InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColour, width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColour, width: 1.5)),
                        errorBorder:
                            OutlineInputBorder(borderSide: BorderSide(width: 1.5)),
                        labelStyle: blackText
                      ),
                    ),
                  ),

                  SizedBox(height: 4,),
            
                  Text(
                    "enter new password",
                    style: blackText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 14),
                  ),

                  SizedBox(
                    height: 2,
                  ),

                  Container(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: TextFormField(
                      obscureText: true,
                      controller: oldPasswordController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColour, width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColour, width: 1.5)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5)),
                          labelStyle: blackText),
                    ),
                  ),

                  SizedBox(
                    height: 4,
                  ),
            
                  Text(
                  "confirm new password",
                  style: blackText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 14),
                ),

                SizedBox(
                height: 2,
                ),

                Container(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: TextFormField(
                    obscureText: true,
                    controller: oldPasswordController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColour, width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColour, width: 1.5)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5)),
                        labelStyle: blackText),
                  ),
                ),

                SizedBox(
                  height: 4,
                ),
                
                ],
              ),
            ]
          ),
        ),
    );
  }
}