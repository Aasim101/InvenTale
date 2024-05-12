import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  static String id = 'profile_screen';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User loggedInUser;
  Color customColor = Color.fromRGBO(32, 61, 79, 1.0);
  Color customColor2 = Color.fromRGBO(28, 183, 167, 1.0);
  Color customColor3 = Color.fromRGBO(219, 225, 227, 1.0);

  @override
  void initState() {
    super.initState();
    // Get the currently logged-in user
    loggedInUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text('Profile'),
      // ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(loggedInUser.uid)
            .collection('user_info')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Extract user's profile data from the snapshot
          final userInfo = snapshot.data!.docs.first;
          final userProfileData = userInfo.data();
          final firstName = userProfileData['first_name'] ?? '';
          final lastName = userProfileData['last_name'] ?? '';
          final followersCount = userProfileData['followers'] ?? 0;
          final followingCount = userProfileData['following'] ?? 0;
          final profilePictureUrl = userProfileData['profile_picture'];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [customColor, customColor2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: profilePictureUrl != null
                            ? NetworkImage(profilePictureUrl)
                            : AssetImage('assets/profile.png') as ImageProvider,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 130,
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            '$firstName $lastName',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCountBox(followersCount.toString(),
                                  'Followers', Colors.white),
                              SizedBox(width: 20),
                              _buildCountBox(followingCount.toString(),
                                  'Following', Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // About Us section
                Container(
                  margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Us', // Heading text
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: customColor, // Custom color for the heading
                        ),
                      ),
                      SizedBox(height: 10),
                      // Spacer between heading and paragraph
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: customColor2), // Greenish border color
                        ),
                        child: Text(
                          "Inventale: Unleash your creativity with our innovative mobile app! Seamlessly blending user authentication, personalized profiles, and collaborative storytelling, Inventale empowers users to craft captivating narratives together. With AI-generated story starters and posters, as well as basic critique and review features, every user becomes a master storyteller. Explore a world of imagination and expression with Inventale today!",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCountBox(String count, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.2), // rgba(255, 255, 255, 0.2)
        borderRadius: BorderRadius.circular(16), // border-radius: 16px
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            // box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1)
            offset: Offset(0, 4),
            blurRadius: 30,
          ),
        ],
        border: Border.all(
          color: Color.fromRGBO(
              255, 255, 255, 0.3), // border: 1px solid rgba(255, 255, 255, 0.3)
        ),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
