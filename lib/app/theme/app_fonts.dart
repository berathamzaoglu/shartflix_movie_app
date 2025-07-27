import 'package:flutter/material.dart';

class AppFonts {
  static const String family = 'EuclidCircular';
  
  // Font weight'ler
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  
  // Özel font stilleri
  static TextStyle get displayLarge => const TextStyle(
    fontFamily: family,
    fontSize: 57,
    fontWeight: light,
    letterSpacing: -0.25,
    height: 1.12,
  );
  
  static TextStyle get displayMedium => const TextStyle(
    fontFamily: family,
    fontSize: 45,
    fontWeight: light,
    letterSpacing: 0,
    height: 1.16,
  );
  
  static TextStyle get displaySmall => const TextStyle(
    fontFamily: family,
    fontSize: 36,
    fontWeight: light,
    letterSpacing: 0,
    height: 1.22,
  );
  
  static TextStyle get headlineLarge => const TextStyle(
    fontFamily: family,
    fontSize: 32,
    fontWeight: semibold,
    letterSpacing: -0.5,
    height: 1.25,
  );
  
  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: family,
    fontSize: 28,
    fontWeight: semibold,
    letterSpacing: -0.25,
    height: 1.29,
  );
  
  static TextStyle get headlineSmall => const TextStyle(
    fontFamily: family,
    fontSize: 24,
    fontWeight: semibold,
    letterSpacing: 0,
    height: 1.33,
  );
  
  static TextStyle get titleLarge => const TextStyle(
    fontFamily: family,
    fontSize: 20,
    fontWeight: medium,
    letterSpacing: 0,
    height: 1.27,
  );
  
  static TextStyle get titleMedium => const TextStyle(
    fontFamily: family,
    fontSize: 18,
    fontWeight: medium,
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static TextStyle get titleSmall => const TextStyle(
    fontFamily: family,
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );
  
  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: family,
    fontSize: 16,
    fontWeight: regular,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: family,
    fontSize: 13,
    fontWeight: regular,
    letterSpacing: 0.25,
    height: 1.43,
  );
  
  static TextStyle get bodySmall => const TextStyle(
    fontFamily: family,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
  );
  
  static TextStyle get labelLarge => const TextStyle(
    fontFamily: family,
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );
  
  static TextStyle get labelMedium => const TextStyle(
    fontFamily: family,
    fontSize: 12,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.33,
  );
  
  static TextStyle get labelSmall => const TextStyle(
    fontFamily: family,
    fontSize: 11,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.45,
  );
  
  // Özel stiller
  static TextStyle get button => const TextStyle(
    fontFamily: family,
    fontSize: 16,
    fontWeight: semibold,
    letterSpacing: 0.1,
  );
  
  static TextStyle get caption => const TextStyle(
    fontFamily: family,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
  );
  
  static TextStyle get overline => const TextStyle(
    fontFamily: family,
    fontSize: 10,
    fontWeight: medium,
    letterSpacing: 1.5,
    height: 1.6,
  );
} 