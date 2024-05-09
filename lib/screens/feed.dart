import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/carousel.dart';
import '../components/AuthorComponent.dart';

class FeedPage extends StatefulWidget {
  static String id = "feed_page";
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late String firstName = ''; // Variable to store the user's first name

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // Fetch user's info when the widget initializes
  }

  // Function to fetch the user's info
  void fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch the user's info from Firestore
      Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('user_info')
          .snapshots();
      stream.listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // Extract the user's first name
          Map<String, dynamic> userInfoData = snapshot.docs.first.data();
          setState(() {
            firstName = userInfoData['first_name'] ?? ''; // Store the user's first name
          });
        } else {
          setState(() {
            firstName = ''; // Set firstName to empty if no data exists
          });
        }
      });
    }
  }

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
            // Display the greeting message with the user's first name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Hi $firstName,',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            StoryCarousel(currentUserId: FirebaseAuth.instance.currentUser?.uid ?? ''), // Display the StoryCarousel component
            // Best Authors section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Best Authors",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Replace AuthorComponent with your implementation
            AuthorComponent(currentUserId: FirebaseAuth.instance.currentUser?.uid ?? ''),
          ],
        ),
      ),
    );
  }
}
