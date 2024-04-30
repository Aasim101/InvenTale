import 'package:flutter/material.dart';
import 'package:dum/components/rounded_button';
import 'package:dum/constants.dart';
class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag : 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('../assets/InvenTale.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(title: 'Log In'
                ,
                colour: Colors.lightBlueAccent,
                onPressed: (){}),
          ],
        ),
      ),
    );
  }
}
