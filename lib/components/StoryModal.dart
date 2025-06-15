import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModal extends StatefulWidget {
  final String title;
  final String content;
  final String storyId;
  final String currentUserId;

  StoryModal({
    required this.title,
    required this.content,
    required this.storyId,
    required this.currentUserId,
  });

  @override
  _StoryModalState createState() => _StoryModalState();
}

class _StoryModalState extends State<StoryModal> {
  int totalRatings = 0;
  double averageRating = 0.0;
  int userRating = 0;
  bool hasRated = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.content,
              style: TextStyle(fontSize: 18.0, color: Colors.black87),
            ),
            SizedBox(height: 20),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                      (index) => IconButton(
                    iconSize: 40,
                    icon: Icon(
                      Icons.star,
                      color: hasRated && userRating >= index + 1 ? Colors.amber : Colors.grey,
                    ),
                    onPressed: hasRated
                        ? null
                        : () async {
                      setState(() {
                        userRating = index + 1;
                      });
                      await _updateRating();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Average Rating:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                Text(
                  averageRating.toStringAsFixed(1),
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(fontSize: 18.0),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, // Set the text color to black
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchRatings();
    _checkIfUserRated();
  }

  Future<void> _fetchRatings() async {
    final docSnapshot = await FirebaseFirestore.instance.collection('stories').doc(widget.storyId).get();
    if (docSnapshot.exists) {
      setState(() {
        totalRatings = docSnapshot['total_ratings'] ?? 0;
        averageRating = docSnapshot['rating']?.toDouble() ?? 0.0; // Convert to double
      });
    }
  }

  Future<void> _updateRating() async {
    final updatedTotalRatings = totalRatings + 1;
    final updatedAverageRating = ((averageRating * totalRatings) + userRating) / updatedTotalRatings;

    await FirebaseFirestore.instance.collection('stories').doc(widget.storyId).update({
      'total_ratings': updatedTotalRatings,
      'rating': updatedAverageRating,
    });
    await FirebaseFirestore.instance
        .collection('stories')
        .doc(widget.storyId)
        .collection('usersHasRated')
        .doc(widget.currentUserId)
        .set({}); // Set an empty object to indicate the user has rated

    setState(() {
      totalRatings = updatedTotalRatings;
      averageRating = updatedAverageRating;
      hasRated = true;
    });
  }

  Future<void> _checkIfUserRated() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('stories')
        .doc(widget.storyId)
        .collection('usersHasRated')
        .doc(widget.currentUserId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        hasRated = true;
      });
      _showAlreadyRatedModal(context);
    }
  }

  void _showAlreadyRatedModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: 48,
              ),
              SizedBox(height: 20),
              Text(
                'You have already rated this story!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Thank you for your rating!',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}

