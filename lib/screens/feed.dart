// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../components/StoryComponent.dart';
//
// class FeedPage extends StatefulWidget {
//   static String id = "feed_page";
//   @override
//   _FeedPageState createState() => _FeedPageState();
// }
//
// class _FeedPageState extends State<FeedPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Feed'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('stories').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No stories available'));
//           }
//
//           // Display stories
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final story = snapshot.data!.docs[index];
//               final userId = story['user_id'];
//               final title = story['title'];
//               final storyContent = story['content'];
//
//               return StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(userId)
//                     .collection('user_info')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return SizedBox.shrink(); // Return an empty widget while fetching user data
//                   }
//                   if (snapshot.hasError) {
//                     return SizedBox.shrink(); // Return an empty widget if there's an error fetching user data
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return SizedBox.shrink(); // Return an empty widget if user data doesn't exist
//                   }
//
//                   // Extract user's profile data from the snapshot
//                   final userInfo = snapshot.data!.docs.first;
//                   final userProfileData = userInfo.data() as Map<String, dynamic>;
//                   final firstName = userProfileData?['first_name'] ?? '';
//                   final lastName = userProfileData?['last_name'] ?? '';
//                   final profilePictureUrl = userProfileData?['profile_picture'] ?? '';
//                   final userName = '$firstName $lastName';
//
//
//
//
//                   // Now, you can use this user data to build your UI or pass it to other components
//                   return StoryComponent(
//                     userName: userName,
//                     profilePictureUrl: profilePictureUrl,
//                     title: title,
//                     story: storyContent,
//                   );
//                 },
//               );
//
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/StoryComponent.dart';
import '../components/AuthorComponent.dart';
import '../components/carousel.dart'; // Import the StoryCarousel component

class FeedPage extends StatefulWidget {
  static String id = "feed_page";
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the logged-in user's name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First Name of the logged in User,',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            // Carousel for stories
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Today's Stories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            StoryCarousel(), // Display the StoryCarousel component
            // Best Authors section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Best Authors",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            AuthorComponent(),
          ],
        ),
      ),
    );
  }
}
