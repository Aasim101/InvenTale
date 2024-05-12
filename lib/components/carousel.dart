import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'StoryPreviewCard.dart';
import 'StoryModal.dart';

class StoryCarousel extends StatelessWidget {
  final String currentUserId;

  StoryCarousel({required this.currentUserId});

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

        final List<DocumentSnapshot> stories = snapshot.data!.docs;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('following')
              .snapshots(),
          builder: (context, followingSnapshot) {
            if (followingSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (followingSnapshot.hasError) {
              return Center(child: Text('Error: ${followingSnapshot.error}'));
            }

            final List<String> followingUserIds = followingSnapshot.data!.docs.map((doc) => doc.id).toList();

            return CarouselSlider.builder(
              itemCount: stories.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                final story = stories[index];
                final userId = story['user_id'];
                final title = story['title'];
                final storyContent = story['content'];

                if (userId == currentUserId || followingUserIds.contains(userId)) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('user_info')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox.shrink();
                      }
                      if (snapshot.hasError) {
                        return SizedBox.shrink();
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return SizedBox.shrink();
                      }

                      final userInfo = snapshot.data!.docs.first;
                      final userProfileData = userInfo.data() as Map<String, dynamic>;
                      final firstName = userProfileData?['first_name'] ?? '';
                      final lastName = userProfileData?['last_name'] ?? '';
                      final profilePictureUrl = userProfileData?['profile_picture'] ?? '';

                      return GestureDetector(
                        onTap: () {
                          _showStoryModal(context, title, storyContent, story.id);
                        },
                        child: AbsorbPointer(
                          child: StoryPreviewCard(
                            firstName: firstName,
                            lastName: lastName,
                            profilePictureUrl: profilePictureUrl,
                            title: title,
                            content: _getStoryPreview(storyContent),
                            totalRatings: story['total_ratings'] ?? 0,
                            rating: story['rating']?.toDouble() ?? 0.0, // Convert to double
                            storyId: story.id,
                            currentUserId: currentUserId,
                          ),
                        ),
                      );
                    },
                  );

                } else {
                  return SizedBox.shrink();
                }
              },
              options: CarouselOptions(
                height: 300,
                viewportFraction: 0.8,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
              ),
            );
          },
        );
      },
    );
  }

  String _getStoryPreview(String content) {
    List<String> words = content.split(' ');
    int length = words.length > 5 ? 5 : words.length;
    return '${words.sublist(0, length).join(' ')}...';
  }

  void _showStoryModal(BuildContext context, String title, String content, String storyId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StoryModal(
          title: title,
          content: content,
          storyId: storyId,
          currentUserId: currentUserId,
        );
      },
    );
  }
}
