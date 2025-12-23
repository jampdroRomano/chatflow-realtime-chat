import 'package:flutter/material.dart';
import 'auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Usamos SingleTickerProviderStateMixin para poder usar AnimationController
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Configura o controlador da animação (Duração total do ciclo)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // 1.0 segundos para tudo
    );

    // Configura a animação de opacidade (vai de 0.0 a 1.0)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Inicia a sequência de animação
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    // 1. Fade In (Aparecer)
    await _controller.forward();
    
    // 2. Pausa breve com o logo visível
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 3. Fade Out (Desaparecer)
    await _controller.reverse();

    // 4. Navegar para a próxima tela (AuthGate)
    // Usamos pushReplacement para que o usuário não possa voltar para a splash screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Importante limpar o controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      // Usa a cor de fundo do tema (que é aquele cinza claro que definimos)
      backgroundColor: theme.scaffoldBackgroundColor, 
      body: Center(
        // FadeTransition aplica a opacidade animada aos seus filhos
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone do App (O mesmo do Login)
              Icon(
                Icons.chat_bubble_outline, 
                size: 100, 
                color: theme.colorScheme.primary
              ),
              const SizedBox(height: 24),
              // Nome do App
              Text(
                'ChatFlow',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900, // Bem negrito
                  color: theme.colorScheme.primary,
                  fontSize: 32,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}