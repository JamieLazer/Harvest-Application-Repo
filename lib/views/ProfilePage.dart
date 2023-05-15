import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../styles.dart';

List userNames = [];
List gardens = [];

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  final Completer<File?> _imageFileCompleter = Completer<File?>();


  Future<void> _getImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _imageFileCompleter.complete(_imageFile);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as List;
    //Extract the user's ID and gardens from the arguments
    String name=arguments[0];
    String surname=arguments[1];
    String email=arguments[2];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: welcomePageText,
        ),
        backgroundColor: primaryColour,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //profile picture + gradient
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
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
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.5),
              child: GestureDetector(
                onDoubleTap: () async {
                  await _getImage();
                  setState(() {});
                },
                //profile photo
                child: FutureBuilder<File?>(
                  future: _imageFileCompleter.future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(snapshot.data!),
                      );
                    } else {
                      return const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white10,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.black54,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "name",
                      style: blackText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 4,),

                    Text(
                        "${name} ${surname}",
                        style: blackText.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.black54,
                          fontSize: 14
                        ),
                        textAlign: TextAlign.left,
                      ),

                      const SizedBox(height: 12,),

                      Text(
                        "email",
                        style: blackText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 14
                          ),
                        ),

                      const SizedBox(height: 4,),

                      Text(
                        "${email}",
                        style: blackText.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.black54,
                          fontSize: 14
                        ),
                        textAlign: TextAlign.left,
                      ),

                      const SizedBox(height: 12,),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/changePassword', arguments: arguments);
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
