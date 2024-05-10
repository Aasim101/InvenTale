import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventale/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MakeProfileScreen extends StatefulWidget {
  static String id = 'make_profile_screen';

  @override
  _MakeProfileScreenState createState() => _MakeProfileScreenState();
}

class _MakeProfileScreenState extends State<MakeProfileScreen> {
  final _auth = FirebaseAuth.instance;
  Color customColor = Color.fromRGBO(32, 61, 79, 1.0);
  Color customColor2 = Color.fromRGBO(28, 183, 167, 1.0);
  final _firestore = FirebaseFirestore.instance;
  late User? loggedInUser;
  late String firstName = '';
  late String lastName = '';
  late int followers = 0;
  late int following = 0;
  File? _image;
  final picker = ImagePicker();
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref(); // Get a reference
        final profileImagesRef = storageRef.child('profile_images'); // Create subfolder
        final userImageRef = profileImagesRef.child('${loggedInUser!.uid}.png');

        // Upload the image to Firebase Storage
        await userImageRef.putFile(_image!);

        // Get the download URL for the uploaded image
        final imageUrl = await userImageRef.getDownloadURL();
        return imageUrl;
      } catch (e) {
        print(e); // Handle potential errors
        return null;
      }
    }
    return null;
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Your Profile'),
      ),

        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Stack (
          children: [Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    firstName = value;
                  },
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(labelText: 'First Name', hintText: 'Enter your First Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: customColor),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customColor),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customColor),
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                ),
                SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    lastName = value;
                  },
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(labelText: 'Last Name', hintText: 'Enter your Last Name',border: OutlineInputBorder(
                    borderSide: BorderSide(color: customColor),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: customColor),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: customColor),
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                ),
                SizedBox(height: 16.0),

                GestureDetector(
                  onTap: getImage,
                  child: CircleAvatar(
                    radius: 75.0,
                    backgroundColor: customColor,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(
                      Icons.add_a_photo,
                      size: 50.0,
                      color: customColor2,
                    )
                        : null,
                  ),
                ),

                SizedBox(height: 16.0),
                ElevatedButton(

                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });

                    if (firstName.isEmpty || lastName.isEmpty) {
                      // Check if mandatory fields are empty
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Missing Information'),
                            content: Text('Please provide both first name and last name.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      setState(() {
                        showSpinner = false;
                      });
                      return;
                    }

                    final imageUrl = await _uploadImage();
                    if (imageUrl != null) {
                      // Create a subcollection for user data within the user's document
                      _firestore.collection('user').doc(loggedInUser!.uid).set({});
                      final userRef = _firestore.collection('users').doc(loggedInUser!.uid);
                      final userInfoRef = userRef.collection('user_info');

                      await userInfoRef.add({
                        'first_name': firstName,
                        'last_name': lastName,
                        'profile_picture': imageUrl,
                        'followers': followers,
                        'following': following,
                      });

                      Navigator.pushNamed(context, ChatScreen.id);
                    } else {
                      print('Image upload failed.');
                    }
                    setState(() {
                      showSpinner = false;

                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(customColor), // Change button background color
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Change text color
                  ),
                  child: Text('Save'),
                ),
              ],
            ),
          ),

            Positioned(
              top: 30.0, // Adjust the position as needed
              right: 180.0,
              child: Image.asset(
                '../assets/InvenTale.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
        ],
        ),
      ),

    );
  }
}

