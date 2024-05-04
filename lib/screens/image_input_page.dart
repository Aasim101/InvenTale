import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageTextInputPage extends StatefulWidget {
  const ImageTextInputPage({super.key});

  @override
  State<ImageTextInputPage> createState() => _ImageTextInputPageState();
}

class _ImageTextInputPageState extends State<ImageTextInputPage> {
  TextEditingController _textController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  String _generatedText = '';
  bool isloading = false;

  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await uploadImage();
    }
  }

  //http://192.168.0.6:5000   https://chatgem.onrender.com
  Future<String> uploadImage() async {
    final url = Uri.parse('https://chatgem.onrender.com/routes/add-image');

    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile(
        'img',
        _image!.readAsBytes().asStream(),
        _image!.lengthSync(),
        filename: 'image.jpg',
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData['path']);
        return responseData['path']; // Retrieve the path to the uploaded image
      } else {
        throw Exception('Failed to upload image1');
      }
    } catch (error) {
      print('Error uploading image: $error');
      throw Exception('Failed to upload image');
    }
  }

  Future<void> generateText() async {
    String textInput = _textController.text;

    if (_image == null) {
      print('No image selected');
      return;
    }

    setState(() {
      isloading = true;
    });

    try {
      final url = Uri.parse('https://chatgem.onrender.com/generateText');

      final requestBody = {
        'textInput': textInput,
        // Remove 'imagePath' as the server code directly reads the image from the uploads directory
      };

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _generatedText = responseData['generatedText'];
          isloading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        print(response.body);
        // Handle error
      }
    } catch (error) {
      print('Error: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'InvenTale',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
              fontFamily: "Cera Pro"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                colors: [
                  Colors.white,
                  Colors.teal
                ],
              )),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 15)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.black),
                          borderRadius: BorderRadius.circular(13))),
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () async {
                    await pickImageFromGallery();
                  },
                  child: const Text('Browse Image',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "Cera Pro")),
                ),
                const SizedBox(height: 10),
                _image != null
                    ? Expanded(
                  child: Image.file(_image!),
                )
                    : const Text(
                  'No image selected yet!',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    // height: 50,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText:
                              'Enter your story...',
                              hintStyle: TextStyle(
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 15)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13))),
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () async {
                    if (_textController.text.isNotEmpty) {
                      await generateText();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter your story...'),
                        ),
                      );
                    }
                  },
                  child: const Text('Get Info',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "Cera Pro")),
                ),
                const SizedBox(height: 20),
                isloading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    : _generatedText.isNotEmpty
                    ? Expanded(
                  child: SingleChildScrollView(
                    child: Text(_generatedText,
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "Cera Pro",
                            color: Colors.black)),
                  ),
                )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
