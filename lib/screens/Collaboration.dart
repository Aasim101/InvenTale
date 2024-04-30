import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/docs/v1.dart' as docs;

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
        child: RaisedButton(
          onPressed: signInWithGoogle,
          child: Text('Sign In with Google'),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;
      if (googleSignInAuthentication != null) {
        // Use googleSignInAuthentication.idToken to authenticate with your backend server.
        // Once authenticated, you can proceed with fetching documents.
        fetchDocuments();
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Future<void> fetchDocuments() async {
    final client = await _googleSignIn.authenticatedClient;
    final api = docs.DocsApi(client);
    final response = await api.documents.get('documentId');
    print(response.body?.content);
    // Once you have fetched documents, you can share the document or listen for changes.
    // For simplicity, let's just print the document content for now.
  }

  Future<void> shareDocument(String documentId, String userEmail) async {
    final client = await _googleSignIn.authenticatedClient;
    final api = docs.PermissionsResourceApi(client);
    final permission = docs.Permission();
    permission.role = 'writer'; // or 'reader'
    permission.emailAddress = userEmail;
    await api.create(permission, documentId);
    // This function shares the document with the specified user.
  }

  void listenForDocumentChanges(String documentId) {
    // Use Google Docs API to listen for changes in the document.
    // Update your app UI accordingly.
  }
}

void main() {
  runApp(MaterialApp(
    home: CollaborativeStoryPage(),
  ));
}
