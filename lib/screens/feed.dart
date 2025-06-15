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
  Color customColor = const Color(0xFF203D4F);
  List<String> _pageTitles = [
    'Feed',
    'Manual Page',
    'Profile',
    'Google Books',
    'Features'
  ];

  final List<ThemeData> _themes = [
    ThemeData(primarySwatch: Colors.blue),
    ThemeData(primarySwatch: Colors.red),
    ThemeData(primarySwatch: Colors.green),
    ThemeData(primarySwatch: Colors.purple),
    ThemeData(
      colorScheme: const ColorScheme.light(
        primary: Colors.white,
        onPrimary: Colors.black,
      ),
    ),
  ];

  int _selectedThemeIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    _widgetOptions = <Widget>[
      _buildFeedContent(),
      ManualPage(),
      ProfilePage(),
      splashscreen(),
      Homepage(),
    ];
  }

  Widget _buildFeedContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi $firstName, how are you doing?',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            "Today's Stories",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          StoryCarousel(currentUserId: FirebaseAuth.instance.currentUser?.uid ?? ''),
          const SizedBox(height: 20),
          const Text(
            "Top Authors",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          AuthorComponent(currentUserId: FirebaseAuth.instance.currentUser?.uid ?? ''),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _showLogoutPrompt(context),
      child: Theme(
        data: _selectedTheme,
        child: Scaffold(
          backgroundColor: _selectedTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              _pageTitles[_selectedIndex],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              PopupMenuButton<int>(
                icon: const Icon(Icons.color_lens),
                onSelected: (index) {
                  setState(() => _selectedThemeIndex = index);
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
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _widgetOptions[_selectedIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: customColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Manual'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
              BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Features'),
            ],
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

  List<String> get _themeNames => ['Blue', 'Red', 'Green', 'Purple', 'White'];

  ThemeData get _selectedTheme => _themes[_selectedThemeIndex];

  void fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('user_info')
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          Map<String, dynamic> userInfoData = snapshot.docs.first.data();
          setState(() {
            firstName = userInfoData['first_name'] ?? '';
          });
        } else {
          setState(() => firstName = '');
        }
      });
    }
  }

  Future<bool> _showLogoutPrompt(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Do you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }
}
