import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../styles.dart';
import '../ConnectionSettings.dart';

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as List;
    //Extract the user's ID and gardens from the arguments
    String email = arguments[2];
    String password = arguments[3];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: secondaryColour),
        title: Text(
          'Change Password',
          style: secondaryColourText,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "enter old password",
                    style: blackText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                //old password
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  height: 50,
                  width: 275,
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
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5)),
                        labelStyle: blackText),
                    validator: (value) {
                          if (value != password) {
                            return 'This password is incorrect';
                          }
                          else {
                            return null;
                          }
                    },
                  ),
                  ),

                const SizedBox(
                  height: 4,
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "enter new password",
                    style: blackText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 14),
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                //new password
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  height: 50,
                  width: 275,
                  child: TextFormField(
                    obscureText: true,
                    controller: newPasswordController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColour, width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColour, width: 1.5)),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 2)),
                        labelStyle: blackText),
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "confirm new password",
                    style: blackText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 14),
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),


                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  height: 50,
                  width: 275,
                  child: TextFormField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColour, width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColour, width: 1.5)),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1.5)),
                        labelStyle: blackText),
                        validator: (value) {
                          if (value != newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          else {
                            return null;
                          }
                        },
                  ),
                ),

                const SizedBox(
                  height: 4,
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
                            
                            var password = newPasswordController.text;
                            //Add the new user to the database (the USER table in the database needs to auto increment user_id for this command to work)
                            try {
                              // Prepare and execute the SQL statement
                              final stmt = await conn.query(
                                'UPDATE USERS SET user_password = ? WHERE user_email = ?',
                                [password, email]
                              );

                              if (stmt.affectedRows == 1) {
                                print('Value updated successfully');
                                Navigator.pop(context);
                              } else {
                                print('Failed to update value');
                              }
                            } catch (e) {
                              print('Error: $e');
                            } finally {
                              // Close the database connection
                              await conn.close();
                            }
                          }
                        },
                        child: Text('Change Password',
                            style: signUpPageText.copyWith(
                              fontSize: 25,
                              color: Colors.white,
                            )))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
