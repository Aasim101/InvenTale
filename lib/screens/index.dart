import 'package:flutter/material.dart';
import '../screens/login.dart';
import 'package:inventale/main.dart';

class MyApp extends StatelessWidget {
  static String id = "main_page";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Stack(
                children: [
                  Positioned(
                    top: constraints.maxHeight / 2 - 300,
                    left: constraints.maxWidth / 2 - 210,
                    child: Image(image: AssetImage('assets/c1.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 - 270,
                    left: constraints.maxWidth / 2 - 210,
                    child: Image(image: AssetImage('assets/c2.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 - 200,
                    left: constraints.maxWidth / 2 - 180,
                    child: Image(image: AssetImage('assets/women.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 - 380,
                    left: constraints.maxWidth / 2 - 50,
                    child: Image(image: AssetImage('assets/c3.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 - 380,
                    left: constraints.maxWidth / 2 - 45,
                    child: Image(image: AssetImage('assets/f1.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 + 60,
                    left: constraints.maxWidth / 2 - 205,
                    child: Image(image: AssetImage('assets/r1.png')),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 + 110,
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
                    top: constraints.maxHeight / 2 + 200,
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
                    top: constraints.maxHeight / 2 + 230,
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
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
                    top: constraints.maxHeight / 2 + 280,
                    left: constraints.maxWidth / 2 - 80,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.teal),
                      ),
                      child: Text(
                        'Login/SignUp',
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
