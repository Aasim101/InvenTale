import 'package:flutter/material.dart';

class StoryComponent extends StatelessWidget {
  final String userName;
  final String profilePictureUrl;
  final String title;
  final String story;

  StoryComponent({
    required this.userName,
    required this.profilePictureUrl,
    required this.title,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    print(profilePictureUrl);
    print(userName);
    print(title);
    print(story);
    print("I am in Component");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(profilePictureUrl),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(width: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                story,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
