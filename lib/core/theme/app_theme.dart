import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Opcional: Se quiser fontes bonitas

class AppTheme {
  // CORES DO SEU PROJETO
  static const Color primaryColor = Color(0xFF125DFF);      // Azul do balão (Eu)
  static const Color secondaryColor = Color(0xFFF2F2F7);    // Cinza do balão (Outros)
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color scaffoldBackground = Colors.white;

  // DEFINIÇÃO DO TEMA LIGHT
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Esquema de Cores Principal
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: Colors.white,
      ),

      // Cor de Fundo das Telas
      scaffoldBackgroundColor: scaffoldBackground,

      // Estilo da AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent, // Remove aquele filtro roxo do Material 3
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Estilo dos Botões (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white, // Cor do texto/ícone
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),

      // Estilo dos Inputs (TextField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      
      // Tipografia Padrão (Textos)
      textTheme: GoogleFonts.interTextTheme(), // Use Inter ou Roboto
    );
  }
}