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
  late String firstName = '';
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

  // Define the available themes
  final List<ThemeData> _themes = [
    ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      brightness: Brightness.light,
    ),
    ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
      brightness: Brightness.light,
    ),
    ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green),
      brightness: Brightness.light,
    ),
    ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple),
      brightness: Brightness.light,
    ),
    ThemeData(
      colorScheme: ColorScheme(
        primary: Colors.white,
        secondary: Colors.black,
        surface: Colors.white,
        background: Colors.white,
        error: Colors.red,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
    ),
  ];

  int _selectedThemeIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    var l = ["mystery", "fantasy", "horror", "health"];
    _widgetOptions = <Widget>[
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Hi, How you are doing?,',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Today's Stories:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            StoryCarousel(
                currentUserId: FirebaseAuth.instance.currentUser?.uid ?? ''),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldLogout = await _showLogoutPrompt(context);
        return shouldLogout;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_pageTitles[_selectedIndex]),
          actions: [
            PopupMenuButton<int>(
              icon: Icon(Icons.color_lens),
              onSelected: (index) {
                setState(() {
                  _selectedThemeIndex = index;
                });
              },
              itemBuilder: (context) => List.generate(
                _themes.length,
                    (index) => PopupMenuItem<int>(
                  value: index,
                  child: Text(_themeNames[index]),
                ),
              ),
            ),
          ],
        ),
        body: Theme(
          data: _selectedTheme,
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          color: customColor,
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
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<String> get _themeNames => [
    'Blue',
    'Red',
    'Green',
    'Purple',
    'White',
  ];

  ThemeData get _selectedTheme => _themes[_selectedThemeIndex];

  void fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .collection('user_info')
          .snapshots();
      stream.listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          Map<String, dynamic> userInfoData = snapshot.docs.first.data();
          setState(() {
            firstName = userInfoData['first_name'] ?? '';
          });
        } else {
          setState(() {
            firstName = '';
          });
        }
      });
    }
  }

  Future<bool> _showLogoutPrompt(BuildContext context) async {
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
              await FirebaseAuth.instance.signOut();
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
