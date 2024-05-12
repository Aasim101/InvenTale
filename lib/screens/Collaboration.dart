import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/docs/v1.dart' as docs;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class CollaborativeStoryPage extends StatefulWidget {
  static String id = "collaborative_page";

  @override
  _CollaborativeStoryPageState createState() => _CollaborativeStoryPageState();
}

class _CollaborativeStoryPageState extends State<CollaborativeStoryPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'YOUR_CLIENT_ID.apps.googleusercontent.com',
    scopes: ['https://www.googleapis.com/auth/documents'],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collaborative Story'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: signInWithGoogle,
          child: Text('Sign In with Google'),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
        final auth.AccessCredentials credentials = await _getCredentials(googleAuth);
        await fetchDocuments(credentials);
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Future<auth.AccessCredentials> _getCredentials(GoogleSignInAuthentication googleAuth) async {
    final DateTime expirationTime = DateTime.now().add(const Duration(hours: 1));
    return auth.AccessCredentials(
      auth.AccessToken(googleAuth.accessToken!, 'Bearer', expirationTime),

      googleAuth.idToken ?? '', // ID Token, can be empty string if not available
      [],
    );
  }

  Future<void> fetchDocuments(auth.AccessCredentials credentials) async {
    try {
      final http.Client client = http.Client();
      final auth.AuthClient authenticatedClient = auth.authenticatedClient(client, credentials);
      final api = docs.DocsApi(authenticatedClient);
      final response = await api.documents.get('documentId'); // Replace 'documentId' with your actual document ID
      print(response.body?.content);
    } catch (error) {
      print('Error fetching documents: $error');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: CollaborativeStoryPage(),
  ));
}
