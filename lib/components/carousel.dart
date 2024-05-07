import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'StoryPreviewCard.dart'; // New component for story preview card

class StoryCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample list of stories, replace with actual data from Firestore
    List<Map<String, String>> stories = [
      {'title': 'Story 1', 'content': 'Once upon a time in a faraway kingdom...'},
      {'title': 'Story 2', 'content': 'In a distant galaxy, there lived a brave warrior...'},
      {'title': 'Story 3', 'content': 'Long ago, in a mystical forest, there was a magical creature...'},
      {'title': 'Story 4', 'content': 'In the depths of the ocean, hidden from human sight, lies a hidden treasure...'},
      {'title': 'Story 5', 'content': 'In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures... In the heart of the jungle, amidst towering trees, there lives a tribe of peaceful creatures...'},
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
      ),
      items: stories.map((story) {
        return Builder(
          builder: (BuildContext context) {
            String title = story['title'] ?? '';
            String content = story['content'] ?? '';
            String preview = _getStoryPreview(content); // Get the first 5 words as preview
            return GestureDetector(
              onTap: () {
                _showStoryModal(context, title, content); // Show modal with full story
              },
              child: AbsorbPointer(
                child: StoryPreviewCard(
                  title: title,
                  content: preview,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  // Function to get the first 5 words of a story as a preview
  String _getStoryPreview(String content) {
    List<String> words = content.split(' ');
    int length = words.length > 5 ? 5 : words.length; // Get up to first 5 words
    return words.sublist(0, length).join(' ');
  }

  // Function to show the modal with full story
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
            height: MediaQuery.of(context).size.height * 0.6, // Adjust height as needed
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


}
