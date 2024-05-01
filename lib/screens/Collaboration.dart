import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/docs/v1.dart' as docs;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class CollaborativeStoryPage extends StatefulWidget {
  @override
  _CollaborativeStoryPageState createState() => _CollaborativeStoryPageState();
}

class _CollaborativeStoryPageState extends State<CollaborativeStoryPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/documents']);

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
        final auth.AccessCredentials credentials = await _getCredentials(googleSignInAccount as String);
        await fetchDocuments(credentials);
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Future<auth.AccessCredentials> _getCredentials(String accessToken, String? idToken) async {
    return auth.AccessCredentials(
      auth.AccessToken(accessToken,['https://www.googleapis.com/auth/documents'] as String, DateTime.now().add(Duration(hours: 1))),
      idToken ?? '', // ID Token, can be empty string if not available
      [],
    );
  }

  Future<void> fetchDocuments(auth.AccessCredentials credentials) async {
    try {
      final http.Client client = http.Client();
      final auth.AuthClient authenticatedClient = auth.authenticatedClient(
        client,
        credentials,
      );
      final api = docs.DocsApi(authenticatedClient);
      final response = await api.documents.get('documentId');
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
