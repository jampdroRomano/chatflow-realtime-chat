import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Placeholder para o chat que faremos depois
          return Scaffold(
             appBar: AppBar(title: const Text("ChatFlow")),
             body: Center(
               child: ElevatedButton(
                 onPressed: () => FirebaseAuth.instance.signOut(), 
                 child: const Text("Sair (Chat em construção)")
               )
             )
          ); 
        }
        return const LoginScreen();
      },
    );
  }
}