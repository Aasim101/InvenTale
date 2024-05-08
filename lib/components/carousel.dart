import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import CarouselSlider
import 'StoryPreviewCard.dart';

class StoryCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        // Extract story data from snapshot
        final List<DocumentSnapshot> stories = snapshot.data!.docs;

        return CarouselSlider.builder(
          itemCount: stories.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final story = stories[index];
            final userId = story['user_id'];
            final title = story['title'];
            final storyContent = story['content'];

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('user_info')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink(); // Return an empty widget while fetching user data
                }
                if (snapshot.hasError) {
                  return SizedBox.shrink(); // Return an empty widget if there's an error fetching user data
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SizedBox.shrink(); // Return an empty widget if user data doesn't exist
                }

                // Extract user's profile data from the snapshot
                final userInfo = snapshot.data!.docs.first;
                final userProfileData = userInfo.data() as Map<String, dynamic>;
                final firstName = userProfileData?['first_name'] ?? '';
                final lastName = userProfileData?['last_name'] ?? '';
                final profilePictureUrl = userProfileData?['profile_picture'] ?? '';
                final userName = '$firstName $lastName';

                return GestureDetector(
                  onTap: () {
                    _showStoryModal(context, title, storyContent);
                  },
                  child: AbsorbPointer(
                    child: StoryPreviewCard(
                      firstName: firstName,
                      lastName: lastName,
                      profilePictureUrl: profilePictureUrl,
                      title: title,
                      content: _getStoryPreview(storyContent),
                    ),
                  ),
                );
              },
            );
          },
          options: CarouselOptions(
            height: 300, // Set the height of the carousel
            viewportFraction: 0.8, // Set the portion of the viewport occupied by each item
            enableInfiniteScroll: true, // Enable infinite scrolling
            autoPlay: true, // Enable auto play
            autoPlayInterval: Duration(seconds: 3), // Set auto play interval
            autoPlayAnimationDuration: Duration(milliseconds: 800), // Set auto play animation duration
            autoPlayCurve: Curves.fastOutSlowIn, // Set auto play curve
            enlargeCenterPage: true, // Enlarge the center item
          ),
        );
      },
    );
  }

  void _showStoryModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
          title: Text(
            title,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Text(
                content,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getStoryPreview(String content) {
    List<String> words = content.split(' ');
    int length = words.length > 5 ? 5 : words.length;
    return words.sublist(0, length).join(' ');
  }
}
