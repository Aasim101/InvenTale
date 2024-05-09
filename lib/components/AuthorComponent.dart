import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorComponent extends StatefulWidget {
  final String currentUserId;

  AuthorComponent({required this.currentUserId});

  @override
  _AuthorComponentState createState() => _AuthorComponentState();
}

class _AuthorComponentState extends State<AuthorComponent> {
  late List<Map<String, dynamic>> _userInfoList;
  late List<String> _userIds;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final snapshot = await FirebaseFirestore.instance.collection('user').get();
    _userIds = snapshot.docs.map((doc) => doc.id).toList();
    _userIds.remove(widget.currentUserId);

    final List<Map<String, dynamic>> userInfoList = [];
    for (final userId in _userIds) {
      final userInfoSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('user_info')
          .get();

      if (userInfoSnapshot.docs.isNotEmpty) {
        final userInfo = userInfoSnapshot.docs.first.data() as Map<String, dynamic>;
        userInfoList.add(userInfo);
      }
    }

    setState(() {
      _userInfoList = userInfoList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userInfoList == null) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _userInfoList.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final userInfo = _userInfoList[index];
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
              onPressed: () async {
                String followedUserId = _userIds[index];

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.currentUserId)
                    .collection('user_info')
                    .get()
                    .then((snapshot) {
                  if (snapshot.docs.isNotEmpty) {
                    String userInfoId = snapshot.docs.first.id;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.currentUserId)
                        .collection('user_info')
                        .doc(userInfoId)
                        .update({'following': FieldValue.increment(1)});
                  }
                });

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(followedUserId)
                    .collection('user_info')
                    .get()
                    .then((snapshot) {
                  if (snapshot.docs.isNotEmpty) {
                    String userInfoId = snapshot.docs.first.id;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(followedUserId)
                        .collection('user_info')
                        .doc(userInfoId)
                        .update({'followers': FieldValue.increment(1)});
                  }
                });

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.currentUserId)
                    .collection('following')
                    .doc(followedUserId)
                    .set({});

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(followedUserId)
                    .collection('followers')
                    .doc(widget.currentUserId)
                    .set({});

                setState(() {
                  _userInfoList.removeAt(index);
                  _userIds.removeAt(index);
                });
              },
              child: Text('Follow'),
            ),
          );
        },
      ),
    );
  }
}
