import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class ManualPage extends StatefulWidget {
  @override
  _ManualPageState createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {
  late User loggedInUser;
  Color customColor = Color.fromRGBO(32, 61, 79, 1.0);
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Get the currently logged-in user
    loggedInUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Write Your Story', // Add a title for the section
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              decoration: InputDecoration(
                labelText: "Title",
                suffixIcon: IconButton(
                  onPressed: () async {
                    final clipboardData =
                        await Clipboard.getData(Clipboard.kTextPlain);
                    if (clipboardData != null && clipboardData.text != null) {
                      _titleController.text = clipboardData.text!;
                      _titleFocusNode.requestFocus();
                    }
                  },
                  icon: Icon(Icons.paste),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11.0),
                  borderSide: BorderSide(color: customColor),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: TextField(
                  controller: _contentController,
                  focusNode: _contentFocusNode,
                  decoration: InputDecoration(
                    labelText: "Content",
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final clipboardData =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (clipboardData != null &&
                            clipboardData.text != null) {
                          _contentController.text = clipboardData.text!;
                          _contentFocusNode.requestFocus();
                        }
                      },
                      icon: Icon(Icons.paste),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: customColor),
                      borderRadius:
                          BorderRadius.circular(11.0), // Set border radius here
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                  maxLines: null, // Allow multiline input
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _postStory,
              style: ElevatedButton.styleFrom(
                backgroundColor: customColor,
                minimumSize: Size(double.infinity, 45),
              ),
              child: Text(
                'Post',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _postStory() {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();
    if (title.isNotEmpty && content.isNotEmpty) {
      // Store the story in the database
      FirebaseFirestore.instance.collection('stories').add({
        'title': title,
        'content': content,
        'user_id': loggedInUser.uid,
        'total_ratings': 0,
        'rating': 5,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) {
        // Clear text fields after posting
        _titleController.clear();
        _contentController.clear();
        // Show success message or navigate to another page
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Story posted successfully'),
          duration: Duration(seconds: 2),
        ));
      }).catchError((error) {
        // Handle errors if any
        print('Error posting story: $error');
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to post story. Please try again later.'),
          duration: Duration(seconds: 2),
        ));
      });
    } else {
      // Show error message if title or content is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please provide a title and content for your story.'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }
}
