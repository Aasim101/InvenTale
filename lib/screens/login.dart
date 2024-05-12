import 'package:flutter/material.dart';
import 'package:inventale/components/rounded_button';
import 'package:inventale/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventale/screens/manualpage.dart';
import "package:inventale/main.dart";
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import './feed.dart';
import './registration.dart';
import './profile.dart';
import 'dart:async';

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
  Color MycustomColor = Color.fromRGBO(32, 61, 79, 1.0);
  Color customColor =  Color.fromRGBO(32, 61, 79, 1.0);
  Color customColor2 = Color.fromRGBO(28, 183, 167, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [
      //         Color(0x803D4F4F), // 50% transparent dark blue
      //         Color(0x801DB8A6), // 50% transparent green
      //         Color(0x803D4F4F), // 50% transparent dark blue
      //       ],
      //       stops: [0.1, 0.5, 0.9],
      //     ),
      //   ),
         body: ModalProgressHUD(
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
                          child: Image.asset('assets/InvenTale.png'),
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
                        prefixIcon: Icon(Icons.email, color: MycustomColor), border: OutlineInputBorder(
                      borderSide: BorderSide(color: customColor),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: customColor),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                        focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: customColor),
                        borderRadius: BorderRadius.circular(30.0),
                      )
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
                        prefixIcon: Icon(Icons.lock, color: MycustomColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: customColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: customColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: customColor),
                            borderRadius: BorderRadius.circular(30.0),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                      title: 'Log In',
                      colour: MycustomColor,
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {

                          // Check if password length is at least 6 characters
                          if (password.length < 6) {
                            // Show error message if password is too short
                            throw FirebaseAuthException(
                              code: 'weak-password',
                              message: 'The password must be at least 6 characters long.',
                            );
                          }

                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            Navigator.pushNamed(context, FeedPage.id);
                            // Navigator.pushNamed(context, ProfilePage.id);
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        }on FirebaseAuthException catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          // Check if the error is due to wrong password
                          if (e.code == 'invalid-credential') {
                            Future.delayed(Duration.zero, () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Login Error"),
                                    content: Text("The Email/Password you entered is incorrect."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            });
                          } else if (e.code == 'weak-password') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Login Error"),
                                  content: Text(e.message ?? "Invalid password."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }  else {
                            // For other errors, just print the error
                            print(e);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                    SizedBox(height: 12),
                      MouseRegion(
                        onEnter: (_) {
                        setState(() {
                        customColor = Color.fromRGBO(28, 183, 167, 1.0);
                      });
                    },
                      onExit: (_) {
                        setState(() {
                        customColor = Color.fromRGBO(35, 61, 79, 1.0);
                     });
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegistrationScreen.id);
                        },
                            child: Text(
                               "Don't Have an Account? Register",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                color: customColor,
                                fontSize: 16.0,
                          ),
                        ),
                      ),
                      ),
                      ],
                ),
              ),
               Positioned(
                 top: 10.0, // Adjust the position as needed
                 right: 10.0,
                 child: Image.asset(
                   'assets/Ellipse.png',
                   width: 90.0,
                   height: 90.0,
               ),
               ),
            ],
          ),
        ),

    );
  }
}
