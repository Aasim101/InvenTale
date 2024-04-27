import 'package:flutter/material.dart';

class ManualPage extends StatefulWidget {
  @override
  _ManualPageState createState() => _ManualPageState();
}

class _ManualPageState extends State{
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: "What's on your mind...",
              ),
              maxLines: null, // Allow multiline input
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Do something with the text, for example, print it
                print(_textEditingController.text);
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
