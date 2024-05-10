import 'package:flutter/material.dart';
import 'package:inventale/components/rounded_button';
import 'package:inventale/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import './login.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'MakeProfileScreen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;
  Color customColor = Color.fromRGBO(32, 61, 79, 1.0);
  Color mycustomColor = Color.fromRGBO(32, 61, 79, 1.0);
  Color customColor2 = Color.fromRGBO(28, 183, 167, 1.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //     body: Container(
    //     decoration: BoxDecoration(
    //     gradient: LinearGradient(
    //     begin: Alignment.topCenter,
    //     end: Alignment.bottomCenter,
    //     colors: [
    //     Color(0x803D4F4F), // 50% transparent dark blue
    //     Color(0x801DB8A6), // 50% transparent green
    //     Color(0x803D4F4F), // 50% transparent dark blue
    //
    // ],
    // stops: [0.1, 0.5, 0.9],
    // ),
    // ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(
        children: [ Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('../assets/InvenTale.png'),
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
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email, color: customColor), border: OutlineInputBorder(
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
                    )),
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
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock, color: customColor), border: OutlineInputBorder(
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
                    )),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title: 'Register',
                  colour: customColor2,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try{
                      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                      if(newUser != null){
                        Navigator.pushNamed(context, MakeProfileScreen.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    }
                    catch(e){
                      print(e);
                    }
                  }),
              SizedBox(height: 12),
              MouseRegion(
                onEnter: (_) {
                  setState(() {
                    // Change text color when hovered
                    mycustomColor = Color.fromRGBO(28, 183, 167, 1.0);
                  });
                },
                onExit: (_) {
                  setState(() {
                    // Restore text color when not hovered
                    mycustomColor = Color.fromRGBO(32, 61, 79, 1.0); // Restore to original color
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  child: Text(
                    "Already Have an Account? Log In",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: mycustomColor,
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
              '../assets/Ellipse2.png',
              width: 100.0,
              height: 100.0,
            ),
          ),

        ],
      ),
        ),

    );
  }
}
