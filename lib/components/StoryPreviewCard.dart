import 'package:flutter/material.dart';

class StoryPreviewCard extends StatelessWidget {
  final String title;
  final String content;
  final String firstName;
  final String lastName;
  final String profilePictureUrl;

  StoryPreviewCard({
    required this.title,
    required this.content,
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add logic to show full story modal
      },
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
                    backgroundImage: NetworkImage(profilePictureUrl),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '$firstName $lastName',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

