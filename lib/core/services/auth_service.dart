import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Login
  Future<UserCredential> signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  // Register (UPDATED to receive Name)
  Future<UserCredential> signUp(String email, String password, String name) async {
    // 1. Create account
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );

    // 2. Update Display Name immediately
    if (userCredential.user != null) {
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload(); // Force refresh
    }

    return userCredential;
  }

  // Logout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}