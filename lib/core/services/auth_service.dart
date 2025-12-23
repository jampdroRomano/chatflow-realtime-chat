import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // LOGIN 
  Future<UserCredential> signIn(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );

    // Verifica se o e-mail foi validado
    if (userCredential.user != null && !userCredential.user!.emailVerified) {
      await _firebaseAuth.signOut();
      throw FirebaseAuthException(
        code: 'email-not-verified', 
        message: 'E-mail não verificado.'
      );
    }

    return userCredential;
  }

  // CADASTRO 
  Future<void> signUp(String email, String password, String name) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );

    if (userCredential.user != null) {
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.sendEmailVerification();
      await _firebaseAuth.signOut();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}