import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // CORES
  static const Color primaryColor = Color(0xFF125DFF);
  static const Color secondaryColor = Color(0xFFF2F2F7);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Colors.green; 
  static const Color scaffoldBackground = Color(0xFFE5E5E5);

  // TEMA PADRÃO (Light)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: scaffoldBackground,

      // AppBar Padrão (Branca com ícones pretos)
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryColor, width: 2)),
      ),
      
      textTheme: GoogleFonts.interTextTheme(),
    );
  }

  // --- TEMA ESPECÍFICO: MODO SELEÇÃO ---
  static ThemeData get selectionTheme {
    return lightTheme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor, // Fundo Azul
        iconTheme: IconThemeData(color: Colors.white), // Ícones Brancos
        actionsIconTheme: IconThemeData(color: Colors.white), // Ações Brancas
        titleTextStyle: TextStyle(
          color: Colors.white, // Título Branco
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Estilo do Input de Chat (Sem bordas)
  static InputDecoration get chatInputDecoration {
    return const InputDecoration(
      hintText: "Digite uma mensagem",
      filled: false,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 12),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
    );
  }
}