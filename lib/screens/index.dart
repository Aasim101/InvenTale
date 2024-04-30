import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('InvenTale'),
        ),
        body: Center(
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 350,
                left: MediaQuery.of(context).size.width / 2 - 210,
                child: Image(image: AssetImage('assets/c1.png')),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 320,
                left: MediaQuery.of(context).size.width / 2 - 210,
                child: Image(image: AssetImage('assets/c2.png')),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 250,
                left: MediaQuery.of(context).size.width / 2 - 180,
                child: Image(image: AssetImage('assets/women.png')),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 420,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: Image(image: AssetImage('assets/c3.png')),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 420,
                left: MediaQuery.of(context).size.width / 2 - 45,
                child: Image(image: AssetImage('assets/f1.png')),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 + 10,
                left: MediaQuery.of(context).size.width / 2 - 205,
                child: Image(image: AssetImage('assets/r1.png')),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 + 50,
                left: MediaQuery.of(context).size.width / 2 - 130,
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
                top: MediaQuery.of(context).size.height / 2 + 140,
                left: MediaQuery.of(context).size.width / 2 - 130,
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
                top: MediaQuery.of(context).size.height / 2 + 170,
                left: MediaQuery.of(context).size.width / 2 - 130,
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
                top: MediaQuery.of(context).size.height / 2 + 220,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
