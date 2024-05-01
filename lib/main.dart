import 'package:inventale/screens/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'screens/manualpage.dart'; // Import the file here
import 'package:provider/provider.dart';
import 'screens/registration.dart';
import 'screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'screens/profile.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: const GenerativeAISample(),
  ));
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
    _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class GenerativeAISample extends StatelessWidget {
  const GenerativeAISample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'InvenTale',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 171, 222, 244),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 171, 222, 244),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          initialRoute: LoginScreen.id,
          routes: {
            RegistrationScreen.id: (context) => RegistrationScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            ProfilePage.id : (context) => ProfilePage(),
            ChatScreen.id: (context) => ChatScreen(),
            MyApp.id: (context) => MyApp(),
          },
        );
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  static String id = 'ai_chatscreen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late User? loggedInUser;
  bool _isManualSelected = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser;
      setState(() {
        loggedInUser = user;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loggedInUser != null
        ? Scaffold(
      body: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: AppBar(
              title: const Text('InvenTale'),
              actions: [
                OverlappingButtons(
                  isManualSelected: _isManualSelected,
                  onPressedManual: () {
                    setState(() {
                      _isManualSelected = true;
                    });
                  },
                  onPressedAI: () {
                    setState(() {
                      _isManualSelected = false;
                    });
                  },
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                  icon: Icon(Icons.lightbulb),
                ),
              ],
            ),
          ),
          Expanded(
            child: ImageWidget(),
          ),
          Expanded(
            child: _isManualSelected
                ? ManualPage()
                : ChatWidget(
              loggedInUser: loggedInUser!,
            ),
          ),
        ],
      ),
    )
        : const CircularProgressIndicator();
  }
}

class OverlappingButtons extends StatelessWidget {
  final bool isManualSelected;
  final VoidCallback onPressedManual;
  final VoidCallback onPressedAI;

  const OverlappingButtons({
    Key? key,
    required this.isManualSelected,
    required this.onPressedManual,
    required this.onPressedAI,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: const Size(200.0, 50.0),
          painter: MyButtonPainter(
            isManualSelected: isManualSelected,
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: onPressedManual,
              child: const Text('   Manual'),
              style: TextButton.styleFrom(
                foregroundColor: isManualSelected ? Colors.green : Colors.grey,
              ),
            ),
            TextButton(
              onPressed: onPressedAI,
              child: const Text('         With AI'),
              style: TextButton.styleFrom(
                foregroundColor: isManualSelected ? Colors.grey : Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MyButtonPainter extends CustomPainter {
  final bool isManualSelected;

  MyButtonPainter({
    required this.isManualSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final halfWidth = size.width / 2;

    final paint = Paint();

    // Define the gradient colors
    final colors = [Color(0xFF1BBAA8), Color(0xFF203D4F)];

    // Create separate gradients for each half based on selection
    final leftGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isManualSelected ? colors : [Colors.white, Colors.white],
    ).createShader(Rect.fromLTWH(0.0, 0.0, halfWidth, size.height));

    final rightGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isManualSelected ? [Colors.white, Colors.white] : colors,
    ).createShader(Rect.fromLTWH(halfWidth, 0.0, halfWidth, size.height));

    // Set paint shader based on selection
    paint.shader = isManualSelected ? leftGradient : rightGradient;

    final path = Path();
    path.addRRect(RRect.fromLTRBR(
        0.0, 0.0, size.width, size.height, Radius.circular(10.0)));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MyButtonPainter oldDelegate) =>
      isManualSelected != oldDelegate.isManualSelected;
}

class ImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/two.png'),
      ),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key, required this.loggedInUser}) : super(key: key);

  final User loggedInUser;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late String messageText;
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode(debugLabel: 'TextField');
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey:
          'AIzaSyAnhmR1EFQGoGR-IE0Iunh0VmX5q7Xjd0Q', // Replace 'YOUR_API_KEY' with your actual API key
    );
    _chat = _model.startChat();
  }

  void _scrollDown() {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = widget.loggedInUser.uid;
    final userChatsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats');

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                _scrollController.jumpTo(
                  _scrollController.offset - details.primaryDelta! / 3,
                );
              },
              child: StreamBuilder<QuerySnapshot>(
                stream: userChatsCollection.orderBy('timestamp').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final history = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemBuilder: (context, idx) {
                      final text = history[idx]['text'] as String;
                      final isFromUser = history[idx]['isFromUser'] as bool;
                      return MessageWidget(
                        text: text,
                        isFromUser: isFromUser,
                      );
                    },
                    itemCount: history.length,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      autofocus: true,
                      focusNode: _textFieldFocus,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: 'Enter a prompt...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(14),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(14),
                          ),
                        ),
                      ),
                      controller: _textController,
                      onSubmitted: (String value) {
                        _sendChatMessage(value, widget.loggedInUser);
                      },
                    ),
                  ),
                ),
                const SizedBox.square(dimension: 5),
                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      _sendChatMessage(
                        _textController.text,
                        widget.loggedInUser,
                      );
                    },
                    icon: const Icon(
                      Icons.send,
                    ),
                  )
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendChatMessage(String message, User loggedInUser) async {
    final _firestore = FirebaseFirestore.instance;
    setState(() {
      _loading = true;
    });

    try {
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      final userId = loggedInUser.uid;
      final userChatsCollection =
          _firestore.collection('users').doc(userId).collection('chats');
      await userChatsCollection.add({
        'text': message,
        'response': text,
        'isFromUser': true, // Indicate that this message is from the user
        'timestamp': Timestamp.now(), // Store the timestamp
      });
      if (text == null) {
        _showError('Empty response.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.text,
    required this.isFromUser,
  }) : super(key: key);

  final String text;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: isFromUser ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: MarkdownBody(data: text),
          ),
        ),
      ],
    );
  }
}

// class ImageWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Image.asset('assets/two.png'),
//       ),
//     );
//   }
// }
