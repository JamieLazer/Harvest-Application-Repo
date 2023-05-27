import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../ConnectionSettings.dart';
import '../styles.dart';

int userID = 0;
String name = ''; //user_fname
String surname = ''; // user_lname
String email = ''; //user_email
String profilePicture = ''; // user_pfp

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  final Completer<File?> _imageFileCompleter = Completer<File?>();

  Future<void> fetchProfilePictureFromFirebase() async {
    try {
      var conn = await MySqlConnection.connect(settings);
      var results = await conn.query(
        'SELECT user_pfp FROM USERS WHERE user_id = ?',
        [userID],
      );

      if (results.isNotEmpty) {
        String? profilePicture = results.first['user_pfp'];

        if (profilePicture != null) {
          Reference storageReference =
          FirebaseStorage.instance.ref().child(profilePicture);
          final fileUrl = await storageReference.getDownloadURL();
          final fileResponse = await http.get(Uri.parse(fileUrl));
          if (fileResponse.statusCode == 200) {
            Uint8List fileBytes = fileResponse.bodyBytes;
            File imageFile = await _writeBytesToFile(fileBytes);
            _imageFile = imageFile;
            _imageFileCompleter.complete(_imageFile);
            setState(() {});
          }
        }
      } else {
        // Handle the case when no profile picture is found for the user
        // You can set a default image or show a placeholder
      }
    } catch (e) {
      print('Error fetching profile picture from Firebase: $e');
    }
  }


  Future<File> _writeBytesToFile(Uint8List bytes) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filePath = '$tempPath/profile_picture.jpg';
    File file = File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? selected = await _picker.pickImage(source: source);

    setState(() {
      _imageFile = selected != null ? File(selected.path) : null;
      uploadProfilePictureToFirebase();
    });
  }

  Future<void> uploadProfilePictureToFirebase() async {
    try {
      if (_imageFile != null) {
        File image = _imageFile!;
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance.ref().child(fileName);

        String token = await FirebaseAuth.instance.currentUser!.getIdToken();

        SettableMetadata metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'Authorization': 'Bearer $token',
          },
        );

        Uint8List fileBytes = await image.readAsBytes();

        await storageReference.putData(fileBytes, metadata);

        // Rest of the code...
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error uploading profile picture to Firebase: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfilePictureFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    userID = arguments[0];
    name = arguments[1]; //user_fname
    surname = arguments[2]; // user_lname
    email = arguments[3]; //user_email
    profilePicture = arguments[4]; // user_pfp

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
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColour, secondaryColour],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Photo Library'),
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
                              title: const Text('Camera'),
                              onTap: () {
                                _pickImage(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: FutureBuilder<File?>(
                  future: _imageFileCompleter.future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            snapshot.data!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        return const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.black54,
                        );
                      }
                    } else {
                      return const CircularProgressIndicator();
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
                    "Name",
                    style: blackText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "$name $surname",
                    style: blackText.copyWith(
                        fontWeight: FontWeight.w300,
                        color: Colors.black54,
                        fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Email",
                    style: blackText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 14),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    email,
                    style: blackText.copyWith(
                        fontWeight: FontWeight.w300,
                        color: Colors.black54,
                        fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/changePassword',
                          arguments: arguments);
                    },
                    child: Text(
                      'Change Password',
                      style: blackText.copyWith(
                        fontSize: 14,
                        color: secondaryColour,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
