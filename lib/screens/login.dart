import 'package:flutter/material.dart';
import 'package:inventale/components/rounded_button';
import 'package:inventale/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'feed.dart';
import './profile.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  Color customColor = Color.fromRGBO(32, 61, 79, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x803D4F4F), // 50% transparent dark blue
              Color(0x801DB8A6), // 50% transparent green
              Color(0x801EA9D2), // 50% transparent blue
              Color(0x803D4F4F), // 50% transparent dark blue

            ],
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          height: 200.0,
                          child: Image.asset('../../assets/InvenTale.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your Email',
                        prefixIcon: Icon(Icons.email, color: customColor),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your Password',
                        prefixIcon: Icon(Icons.lock, color: customColor),
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                      title: 'Log In',
                      colour: customColor,
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            Navigator.pushNamed(context, FeedPage.id);
                            // Navigator.pushNamed(context, ProfilePage.id);
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10.0, // Adjust the position as needed
                right: 10.0,
                child: Image.asset(
                  '../assets/Ellipse.png',
                  width: 90.0,
                  height: 90.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


