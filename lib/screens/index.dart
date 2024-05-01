import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String id = "main_page";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('InvenTale'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Stack(
                children: [
                  Positioned(
                    top: constraints.maxHeight / 2 - 350,
                    left: constraints.maxWidth / 2 - 210,
                    child: Image(image: AssetImage('assets/c1.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 - 320,
                    left: constraints.maxWidth / 2 - 210,
                    child: Image(image: AssetImage('assets/c2.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 - 250,
                    left: constraints.maxWidth / 2 - 180,
                    child: Image(image: AssetImage('assets/women.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 - 420,
                    left: constraints.maxWidth / 2 - 50,
                    child: Image(image: AssetImage('assets/c3.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 - 420,
                    left: constraints.maxWidth / 2 - 45,
                    child: Image(image: AssetImage('assets/f1.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 + 10,
                    left: constraints.maxWidth / 2 - 205,
                    child: Image(image: AssetImage('assets/r1.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 + 50,
                    left: constraints.maxWidth / 2 - 130,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Let's hear ",
                          ),
                          TextSpan(
                            text: "stories",
                            style: TextStyle(
                              color: Colors.teal,
                            ),
                          ),
                          TextSpan(
                            text: "\nfrom you",
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 + 140,
                    left: constraints.maxWidth / 2 - 130,
                    child: Text(
                      "Unleash Your Imagination with\n",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 + 170,
                    left: constraints.maxWidth / 2 - 130,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "InvenTale",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ": Where AI and Stories\nCollide",
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 + 220,
                    left: constraints.maxWidth / 2 - 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.teal),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
