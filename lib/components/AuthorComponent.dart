import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _fetchUserIds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final List<String> userIds = snapshot.data ?? [];

        return SingleChildScrollView(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchUserInfo(userIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink();
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final List<Map<String, dynamic>> userInfoList = snapshot.data ?? [];

              return ListView.builder(
                shrinkWrap: true,
                itemCount: userInfoList.length,
                itemBuilder: (context, index) {
                  final userInfo = userInfoList[index];
                  final firstName = userInfo['first_name'] ?? '';
                  final lastName = userInfo['last_name'] ?? '';
                  final profilePictureUrl = userInfo['profile_picture'] ?? '';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profilePictureUrl),
                    ),
                    title: Text(firstName),
                    subtitle: Text(lastName),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Add logic for following the author
                      },
                      child: Text('Follow'),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<List<String>> _fetchUserIds() async {
    try {
      print("hi");
      // Retrieve all user records from Firebase Authentication
      List<User?> users = await FirebaseAuth.instance.authStateChanges().toList();
      print("hi");
      // Extract user IDs
      List<String> userIds = users.where((user) => user != null).map((user) => user!.uid).toList();

      return userIds;
    } catch (error) {
      throw error;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchUserInfo(List<String> userIds) async {
    List<Map<String, dynamic>> userInfoList = [];
    for (String userId in userIds) {
      // Fetch user info from the user_info subcollection
      QuerySnapshot userInfoSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('user_info')
          .get();

      if (userInfoSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userInfo = userInfoSnapshot.docs.first.data() as Map<String, dynamic>;
        userInfoList.add(userInfo);
      }
    }
    return userInfoList;
  }
}
