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
        title: Text('Create Profile'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  firstName = value;
                },
                decoration: kTextFieldDecoration.copyWith(labelText: 'First Name'),
              ),
              SizedBox(height: 8.0),
              TextField(
                onChanged: (value) {
                  lastName = value;
                },
                decoration: kTextFieldDecoration.copyWith(labelText: 'Last Name'),
              ),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: getImage,
                child: Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _image != null
                      ? kIsWeb
                      ? Image.network(_image!.path)
                      : Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    Icons.add_a_photo,
                    size: 50.0,
                    color: Colors.grey[400],
                  ),
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
                child: Text('Create Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
