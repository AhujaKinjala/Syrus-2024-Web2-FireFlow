import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String verifyId = "";

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> addUserToFirestore(
      String userId, String username, String email) async {
    try {
      // Check if 'users' collection exists, create it if not
      CollectionReference usersCollection = _firestore.collection('users');

      if (!(await usersCollection.doc(userId).get()).exists) {
        await usersCollection.doc(userId).set({});
      }

      // Add user data to the 'users' collection
      await usersCollection.doc(userId).set({
        'name': username,
        'email': email,
      });
    } catch (e) {
      print('Error adding user to Firestore: $e');
      throw e;
    }
  }

  // Register User
  Future<void> registerUser(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After registration, add user data to Firestore
      await addUserToFirestore(userCredential.user!.uid, username, email);
    } catch (e) {
      print('Error registering user: $e');
      throw e;
    }
  }

  // Sign In
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error signing in: $e');
      throw e;
    }
  }

  // // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw e;
    }
  }

  //logout
  static Future logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw e;
    }
  }

  //check whether user logged out
  static Future<bool> isLoggedIn() async {
    var user = _auth.currentUser;
    return user != null;
  }
}
