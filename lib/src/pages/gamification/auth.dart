import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:neuroparenting/src/pages/gamification/db.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    DateTime currentTime = DateTime.now();
    String formattedCurrentDate = DateFormat.yMMMd().format(currentTime);
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: currentUser?.email)
        .get()
        .then((matches) async {
      String? lastLogin = matches.docs[0].get('last_login');
      if (lastLogin == null || lastLogin != formattedCurrentDate) {
        await DatabaseManager().updateUserLastLogin(
            email: currentUser?.email, lastLogin: formattedCurrentDate);
      }
    });
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    DateTime currentTime = DateTime.now();
    String formattedCurrentDate = DateFormat.yMMMd().format(currentTime);
    await DatabaseManager().addCollectionUser(
        email: currentUser?.email, currentDate: formattedCurrentDate);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
