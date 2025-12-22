import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/screens/auth_gate.dart';
import 'core/theme/app_theme.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ChatFlowApp());
}

class ChatFlowApp extends StatelessWidget {
  const ChatFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        title: 'ChatFlow',
        debugShowCheckedModeBanner: false,
        
        // APLICANDO O TEMA AQUI:
        theme: AppTheme.lightTheme, 
        
        home: const AuthGate(),
      ),
    );
  }
}