import 'package:flutter/material.dart';

class AuthorComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace the following with actual data from Firestore
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5, // Replace with the actual number of authors
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            // Replace with author's profile picture
            backgroundImage: AssetImage('assets/default_profile_picture.jpg'),
          ),
          title: Text('Author First Name'),
          subtitle: Text('Author Last Name'),
          trailing: ElevatedButton(
            onPressed: () {
              // Add logic for following the author
            },
            child: Text('Follow'),
          ),
        );
      },
    );
  }
}
