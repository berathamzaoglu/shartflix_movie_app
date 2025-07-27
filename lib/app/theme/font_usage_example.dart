import 'package:flutter/material.dart';
import 'app_fonts.dart';

/// Font kullanım örnekleri
/// Bu dosya, AppFonts sınıfının nasıl kullanılacağını gösterir
class FontUsageExample {
  
  /// Display stilleri örnekleri
  static Widget displayExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Large', style: AppFonts.displayLarge),
        Text('Display Medium', style: AppFonts.displayMedium),
        Text('Display Small', style: AppFonts.displaySmall),
      ],
    );
  }
  
  /// Headline stilleri örnekleri
  static Widget headlineExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Headline Large', style: AppFonts.headlineLarge),
        Text('Headline Medium', style: AppFonts.headlineMedium),
        Text('Headline Small', style: AppFonts.headlineSmall),
      ],
    );
  }
  
  /// Title stilleri örnekleri
  static Widget titleExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Title Large', style: AppFonts.titleLarge),
        Text('Title Medium', style: AppFonts.titleMedium),
        Text('Title Small', style: AppFonts.titleSmall),
      ],
    );
  }
  
  /// Body stilleri örnekleri
  static Widget bodyExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Body Large - Bu uzun bir metin örneğidir ve body large stilini göstermek için kullanılmaktadır.', 
             style: AppFonts.bodyLarge),
        Text('Body Medium - Bu orta uzunlukta bir metin örneğidir.', 
             style: AppFonts.bodyMedium),
        Text('Body Small - Kısa metin örneği.', 
             style: AppFonts.bodySmall),
      ],
    );
  }
  
  /// Label stilleri örnekleri
  static Widget labelExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Label Large', style: AppFonts.labelLarge),
        Text('Label Medium', style: AppFonts.labelMedium),
        Text('Label Small', style: AppFonts.labelSmall),
      ],
    );
  }
  
  /// Özel stiller örnekleri
  static Widget customStyleExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Button Style', style: AppFonts.button),
        Text('Caption Style', style: AppFonts.caption),
        Text('Overline Style', style: AppFonts.overline),
      ],
    );
  }
  
  /// Font weight örnekleri
  static Widget fontWeightExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Light Weight', style: TextStyle(fontFamily: AppFonts.family, fontWeight: AppFonts.light)),
        Text('Regular Weight', style: TextStyle(fontFamily: AppFonts.family, fontWeight: AppFonts.regular)),
        Text('Medium Weight', style: TextStyle(fontFamily: AppFonts.family, fontWeight: AppFonts.medium)),
        Text('Semibold Weight', style: TextStyle(fontFamily: AppFonts.family, fontWeight: AppFonts.semibold)),
        Text('Bold Weight', style: TextStyle(fontFamily: AppFonts.family, fontWeight: AppFonts.bold)),
      ],
    );
  }
  
  /// Tüm örnekleri gösteren widget
  static Widget allExamples() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('=== DISPLAY STYLES ===', style: TextStyle(fontWeight: FontWeight.bold)),
          displayExamples(),
          const SizedBox(height: 24),
          
          const Text('=== HEADLINE STYLES ===', style: TextStyle(fontWeight: FontWeight.bold)),
          headlineExamples(),
          const SizedBox(height: 24),
          
          const Text('=== TITLE STYLES ===', style: TextStyle(fontWeight: FontWeight.bold)),
          titleExamples(),
          const SizedBox(height: 24),
          
          const Text('=== BODY STYLES ===', style: TextStyle(fontWeight: FontWeight.bold)),
          bodyExamples(),
          const SizedBox(height: 24),
          
          const Text('=== LABEL STYLES ===', style: TextStyle(fontWeight: FontWeight.bold)),
          labelExamples(),
          const SizedBox(height: 24),
          
          const Text('=== CUSTOM STYLES ===', style: TextStyle(fontWeight: FontWeight.bold)),
          customStyleExamples(),
          const SizedBox(height: 24),
          
          const Text('=== FONT WEIGHTS ===', style: TextStyle(fontWeight: FontWeight.bold)),
          fontWeightExamples(),
        ],
      ),
    );
  }
}

/// Kullanım örnekleri:
/// 
/// 1. Direkt stil kullanımı:
/// Text('Başlık', style: AppFonts.headlineLarge)
/// 
/// 2. Tema ile kullanım:
/// Text('Başlık', style: Theme.of(context).textTheme.headlineLarge)
/// 
/// 3. Özel stil oluşturma:
/// TextStyle(
///   fontFamily: AppFonts.family,
///   fontWeight: AppFonts.semibold,
///   fontSize: 18,
/// )
/// 
/// 4. Mevcut stili genişletme:
/// AppFonts.bodyLarge.copyWith(
///   color: Colors.red,
///   fontSize: 20,
/// ) 