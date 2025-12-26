import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/chat_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'auth_screen.dart';
import 'chat_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AuthViewModel, bool>(
      selector: (_, viewModel) => viewModel.isLoading,
      builder: (context, isLoading, child) {

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
          
            if (isLoading) {
              return const AuthScreen();
            }

            // 2. Lógica normal de autenticação
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            
            if (snapshot.hasData && snapshot.data != null) {
              User user = snapshot.data!;
              if (user.emailVerified) {
                return _buildChatScreen(user);
              }

              return FutureBuilder<void>(
                future: user.reload(), 
                builder: (context, reloadSnapshot) {
                  if (reloadSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final freshUser = FirebaseAuth.instance.currentUser;
                  if (freshUser != null && freshUser.emailVerified) {
                    return _buildChatScreen(freshUser);
                  }
                  return const AuthScreen();
                },
              );
            }
            
            return const AuthScreen();
          },
        );
      },
    );
  }

  Widget _buildChatScreen(User user) {
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