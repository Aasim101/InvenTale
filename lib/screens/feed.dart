import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/StoryComponent.dart';

class FeedPage extends StatefulWidget {
  static String id = "feed_page";
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late User loggedInUser;

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
        title: Text('Feed'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('stories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No stories available'));
          }

          // Display stories
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final story = snapshot.data!.docs[index];
              final userId = story['user_id'];
              final title = story['title'];
              final storyContent = story['content'];
              print(title);
              print(storyContent);
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink(); // Return an empty widget while fetching user data
                  }
                  if (userSnapshot.hasError) {
                    return SizedBox.shrink(); // Return an empty widget if there's an error fetching user data
                  }
                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return SizedBox.shrink(); // Return an empty widget if user data doesn't exist
                  }

                  final userName = '${userSnapshot.data!['first_name']} ${userSnapshot.data!['last_name']}';
                  final profilePictureUrl = userSnapshot.data!['profile_picture'];
                  print(userName);
                  print(profilePictureUrl);
                  return StoryComponent(

                    userName: userName,
                    profilePictureUrl: profilePictureUrl,
                    title: title,
                    story: storyContent,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
