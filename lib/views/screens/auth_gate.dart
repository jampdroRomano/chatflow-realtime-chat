import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/chat_viewmodel.dart';
import 'auth_screen.dart';
import 'chat_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        // 1. Enquanto o Firebase verifica o estado, mostra carregando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Verifica se existe usuário logado
        if (snapshot.hasData) {
          final user = snapshot.data!;

          // 3. AQUI ESTÁ A LÓGICA QUE VOCÊ QUER:
          // Só entra se o e-mail estiver validado
          if (user.emailVerified) {
            return ChangeNotifierProvider(
              create: (_) => ChatViewModel(
                currentUserId: user.uid,
                currentUserName: user.displayName ?? 'Usuário',
                currentUserEmail: user.email ?? '',
              ),
              child: const ChatScreen(),
            );
          }
        }

        // 4. Se não estiver logado OU e-mail não validado, manda para o Login
        return const AuthScreen();
      },
    );
  }
}