import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManualPage extends StatefulWidget {

  @override
  _ManualPageState createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {
  late User loggedInUser;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get the currently logged-in user
    loggedInUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(

                labelText: "Content",
              ),
              maxLines: null, // Allow multiline input
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _postStory();
              },
              child: Text('Post'),
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
    super.dispose();
  }
}
