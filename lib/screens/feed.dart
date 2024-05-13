import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/carousel.dart';
import '../components/AuthorComponent.dart';
import './profile.dart';
import './loadingscreen.dart';
import './features.dart';
import './manualpage.dart';
import './splashscreen.dart';
import './login.dart';

class FeedPage extends StatefulWidget {
  static String id = "feed_page";

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late String firstName = ''; // Variable to store the user's first name
  late List<Widget> _widgetOptions;
  late int _selectedIndex = 0;
  Color customColor = Color.fromRGBO(32, 61, 79, 1.0);
  List<String> _pageTitles = [
    'Feed',
    'Manual Page',
    'Profile',
    'Google Books',
    'Features'
  ];

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // Fetch user's info when the widget initializes
    var l = ["mystery", "fantasy", "horror", "health"];
    _widgetOptions = <Widget>[
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the greeting message with the user's first name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Hi, How you are doing?,',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Carousel for stories
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Today's Stories:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            StoryCarousel(
                currentUserId: FirebaseAuth.instance.currentUser?.uid ?? ''),
            // Display the StoryCarousel component
            // Best Authors section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Best Authors",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            AuthorComponent(
                currentUserId: FirebaseAuth.instance.currentUser?.uid ?? ''),
          ],
        ),
      ),
      ManualPage(),
      ProfilePage(),
      splashscreen(),
      Homepage(),
    ];
  }

  // Method to handle tap events on bottom navigation bar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  // Function to fetch the user's info
  void fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch the user's info from Firestore
      Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .collection('user_info')
          .snapshots();
      stream.listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // Extract the user's first name
          Map<String, dynamic> userInfoData = snapshot.docs.first.data();
          setState(() {
            firstName =
                userInfoData['first_name'] ?? ''; // Store the user's first name
          });
        } else {
          setState(() {
            firstName = ''; // Set firstName to empty if no data exists
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Custom back button behavior
        bool shouldLogout = await _showLogoutPrompt(context);
        return shouldLogout;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_pageTitles[_selectedIndex]),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          color: customColor, // Set the background color here
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Feed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Manual Page',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Google Books',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Features',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: customColor,
            // Change the color of unselected items
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Future<bool> _showLogoutPrompt(BuildContext context) async {
    // Show the logout prompt
    bool shouldLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Do you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              // Logout the user
              await FirebaseAuth.instance.signOut();
              // Navigate to the login screen
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );

    return shouldLogout ?? false;
  }
}
