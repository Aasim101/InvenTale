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
  final Color customColor = Color.fromRGBO(32, 61, 79, 1.0);
  final Color customColor2 = Color.fromRGBO(28, 183, 167, 1.0);

  @override
  void initState() {
    super.initState();
    loggedInUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return Center(child: Text('Error: \${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final userInfo = snapshot.data!.docs.first;
          final data = userInfo.data();
          final firstName = data['first_name'] ?? '';
          final lastName = data['last_name'] ?? '';
          final followers = data['followers'] ?? 0;
          final following = data['following'] ?? 0;
          final profilePicture = data['profile_picture'];

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [customColor, customColor2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: profilePicture != null
                            ? NetworkImage(profilePicture)
                            : AssetImage('assets/profile.png') as ImageProvider,
                        backgroundColor: Colors.grey[300],
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$firstName $lastName',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(child: _buildStatBox(followers.toString(), 'Followers')),
                                SizedBox(width: 8),
                                Expanded(child: _buildStatBox(following.toString(), 'Following')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: customColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: customColor2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Inventale: Unleash your creativity with our innovative mobile app! Seamlessly blending user authentication, personalized profiles, and collaborative storytelling, Inventale empowers users to craft captivating narratives together. With AI-generated story starters and posters, as well as basic critique and review features, every user becomes a master storyteller. Explore a world of imagination and expression with Inventale today!",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatBox(String count, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
