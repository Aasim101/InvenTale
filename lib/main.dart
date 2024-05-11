import 'package:firebase_core/firebase_core.dart';
import 'package:inventale/screens/index.dart';
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
import 'screens/homescreen.dart';
import 'screens/profile.dart';
import 'screens/loadingscreen.dart';
import 'screens/history_screen.dart';
import 'screens/MakeProfileScreen.dart';
import 'screens/feed.dart';
import 'screens/features.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: GenerativeAISample(),
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
    var l = ["mystery", "fantasy", "horror", "romance"];
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
            ProfilePage.id: (context) => ProfilePage(),
            loadingscreen.id: (context) => loadingscreen(l: l),
            ChatScreen.id: (context) => ChatScreen(title: 'InvenTale'),
            MyApp.id: (context) => MyApp(),
            MakeProfileScreen.id: (context) => MakeProfileScreen(),
            FeedPage.id: (context) => FeedPage(),
            Homepage.id: (context) => Homepage(),
          },
        );
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  static String id = 'ai_chatscreen';

  const ChatScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late User? loggedInUser; // Make loggedInUser nullable

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
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.title),
                  const SizedBox(width: 16),
                  OverlappingButtons(),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(
                          loggedInUser: loggedInUser!,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.history),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ImageWidget(),
                ),
                Expanded(
                  child: ChatWidget(
                    apiKey: "AIzaSyAnhmR1EFQGoGR-IE0Iunh0VmX5q7Xjd0Q",
                    loggedInUser: loggedInUser,
                  ),
                ),
              ],
            ),
          )
        : CircularProgressIndicator(); // Show loading indicator while user is being fetched
  }
}

class OverlappingButtons extends StatefulWidget {
  @override
  _OverlappingButtonsState createState() => _OverlappingButtonsState();
}

class _OverlappingButtonsState extends State<OverlappingButtons> {
  bool _isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(200.0, 50.0),
          //painter: MyButtonPainter(_isSelected, _isManualSelected),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManualPage()),
                );
              },
              child: Text('   Manual'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () => setState(() {
                _isSelected = true;
              }),
              child: Text('         With AI'),
              style: TextButton.styleFrom(
                foregroundColor: _isSelected ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MyButtonPainter extends CustomPainter {
  final bool _isSelected;
  final bool _isManualSelected;

  MyButtonPainter(this._isSelected, this._isManualSelected);

  @override
  void paint(Canvas canvas, Size size) {
    final halfWidth = size.width / 2;

    final paint = Paint();

    if (_isSelected) {
      // Define the gradient colors
      final colors = [Color(0xFF1BBAA8), Color(0xFF203D4F)];

      // Create separate gradients for each half based on selection
      final leftGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _isManualSelected ? colors : [Colors.white, Colors.white],
      ).createShader(Rect.fromLTWH(0.0, 0.0, halfWidth, size.height));

      final rightGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _isManualSelected ? [Colors.white, Colors.white] : colors,
      ).createShader(Rect.fromLTWH(halfWidth, 0.0, halfWidth, size.height));

      // Set paint shader based on selection
      paint.shader = _isManualSelected ? leftGradient : rightGradient;
    } else {
      paint.color = Colors.white; // Default white for unselected state
    }

    final path = Path();
    path.addRRect(RRect.fromLTRBR(
        0.0, 0.0, size.width, size.height, Radius.circular(10.0)));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MyButtonPainter oldDelegate) =>
      _isSelected != oldDelegate._isSelected ||
      _isManualSelected != oldDelegate._isManualSelected;
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    Key? key,
    required this.apiKey,
    required this.loggedInUser,
  }) : super(key: key);

  final String apiKey;
  final User? loggedInUser;

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
      apiKey: widget.apiKey,
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
    final history = _chat.history.toList();
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
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemBuilder: (context, idx) {
                  final content = history[history.length - 1 - idx];
                  final text = content.parts
                      .whereType<TextPart>()
                      .map<String>((e) => e.text)
                      .join('');
                  return MessageWidget(
                    text: text,
                    isFromUser: content.role == 'user',
                  );
                },
                itemCount: history.length,
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
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      autofocus: true,
                      focusNode: _textFieldFocus,
                      decoration: textFieldDecoration(
                        context,
                        'Enter a prompt...',
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          final clipboardData =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          if (clipboardData != null &&
                              clipboardData.text != null) {
                            _textController.text = clipboardData.text!;
                            _textFieldFocus.requestFocus();
                          }
                        },
                        icon: Icon(
                          Icons.paste,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          _sendChatMessage(
                              _textController.text, widget.loggedInUser);
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await Clipboard.setData(
                              ClipboardData(text: _textController.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Text copied to clipboard'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.copy,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
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

  Future<void> _sendChatMessage(String message, User? loggedInUser) async {
    if (loggedInUser == null) {
      return; // Do nothing if user is null
    }

    final _firestore = FirebaseFirestore.instance;
    setState(() {
      _loading = true;
    });

    try {
      final response = await _chat.sendMessage(Content.text(message));
      final text = response.text;
      if (text == null) {
        _showError('Empty response.');
        return;
      } else {
        // Get the user's document reference
        final userRef = _firestore.collection('users').doc(loggedInUser.uid);

        // Create a new chat document
        final chatRef = userRef.collection('chats').doc();

        // Set chat data
        await chatRef.set({
          'message': message,
          'response': text,
          'sender': loggedInUser.email,
          'timestamp': FieldValue.serverTimestamp(),
        });

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
              color: isFromUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceVariant,
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

class ImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/two.png'),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return TextButton.icon(
                        onPressed: () {
                          themeProvider.toggleTheme();
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: themeProvider.themeMode == ThemeMode.light
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.primary,
                              width: 2.0,
                            ),
                          ),
                        ),
                        label: Text(
                          'Change to the ${themeProvider.themeMode == ThemeMode.light ? 'dark' : 'light'} theme',
                        ),
                        icon: Transform.rotate(
                          angle: -1.0,
                          child: Icon(Icons.arrow_forward),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

InputDecoration textFieldDecoration(BuildContext context, String hintText) =>
    InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
