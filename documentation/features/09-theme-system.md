# Theme System

## Overview

The ShartFlix application implements a comprehensive theme system supporting both dark and light modes with custom color schemes, theme persistence, and smooth transitions. The theme system is built using Flutter's Material Design 3 principles and provides consistent visual experience across all platforms.

## Theme Architecture

### Theme Configuration
```dart
// app_theme.dart
class AppTheme {
  static const String fontFamily = 'Inter';
  
  // Light Theme Configuration
  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.lightSurface,
      onSurface: AppColors.onLightSurface,
      background: AppColors.lightBackground,
      onBackground: AppColors.onLightBackground,
      surfaceVariant: AppColors.lightSurfaceVariant,
      onSurfaceVariant: AppColors.onLightSurfaceVariant,
      outline: AppColors.lightOutline,
      shadow: AppColors.shadow,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      
      // App Bar Theme
      appBarTheme: _buildAppBarTheme(colorScheme),
      
      // Navigation Bar Theme
      navigationBarTheme: _buildNavigationBarTheme(colorScheme),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(colorScheme),
      
      // Card Theme
      cardTheme: _buildCardTheme(colorScheme),
      
      // Input Decoration Theme
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      
      // Button Themes
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      filledButtonTheme: _buildFilledButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      
      // Text Theme
      textTheme: _buildTextTheme(colorScheme),
      
      // Icon Theme
      iconTheme: _buildIconTheme(colorScheme),
      
      // Divider Theme
      dividerTheme: _buildDividerTheme(colorScheme),
      
      // Bottom Sheet Theme
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      
      // Dialog Theme
      dialogTheme: _buildDialogTheme(colorScheme),
      
      // Snack Bar Theme
      snackBarTheme: _buildSnackBarTheme(colorScheme),
      
      // Progress Indicator Theme
      progressIndicatorTheme: _buildProgressIndicatorTheme(colorScheme),
    );
  }

  // Dark Theme Configuration
  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.onPrimaryDark,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.onSecondaryDark,
      tertiary: AppColors.tertiaryDark,
      onTertiary: AppColors.onTertiaryDark,
      error: AppColors.errorDark,
      onError: AppColors.onErrorDark,
      surface: AppColors.darkSurface,
      onSurface: AppColors.onDarkSurface,
      background: AppColors.darkBackground,
      onBackground: AppColors.onDarkBackground,
      surfaceVariant: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.onDarkSurfaceVariant,
      outline: AppColors.darkOutline,
      shadow: AppColors.shadow,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      
      // Similar theme configurations as light theme
      appBarTheme: _buildAppBarTheme(colorScheme),
      navigationBarTheme: _buildNavigationBarTheme(colorScheme),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(colorScheme),
      cardTheme: _buildCardTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      filledButtonTheme: _buildFilledButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      textTheme: _buildTextTheme(colorScheme),
      iconTheme: _buildIconTheme(colorScheme),
      dividerTheme: _buildDividerTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      dialogTheme: _buildDialogTheme(colorScheme),
      snackBarTheme: _buildSnackBarTheme(colorScheme),
      progressIndicatorTheme: _buildProgressIndicatorTheme(colorScheme),
    );
  }

  // Component Theme Builders
  static AppBarTheme _buildAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.headlineSmall.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: colorScheme.brightness == Brightness.light 
            ? Brightness.dark 
            : Brightness.light,
        statusBarBrightness: colorScheme.brightness,
      ),
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primary.withOpacity(0.12),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppTextStyles.labelSmall.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          );
        }
        return AppTextStyles.labelSmall.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return IconThemeData(
            color: colorScheme.primary,
            size: 24,
          );
        }
        return IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: 24,
        );
      }),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme(ColorScheme colorScheme) {
    return BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTextStyles.labelSmall,
    );
  }

  static CardTheme _buildCardTheme(ColorScheme colorScheme) {
    return CardTheme(
      color: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.5),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.5),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme(ColorScheme colorScheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(
          color: colorScheme.primary,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      displaySmall: AppTextStyles.displaySmall.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(
        color: colorScheme.onSurface,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      titleSmall: AppTextStyles.titleSmall.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      labelLarge: AppTextStyles.labelLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      labelSmall: AppTextStyles.labelSmall.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static IconThemeData _buildIconTheme(ColorScheme colorScheme) {
    return IconThemeData(
      color: colorScheme.onSurface,
      size: 24,
    );
  }

  static DividerThemeData _buildDividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.outline.withOpacity(0.2),
      thickness: 1,
      space: 1,
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      modalBackgroundColor: colorScheme.surface,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
    );
  }

  static DialogTheme _buildDialogTheme(ColorScheme colorScheme) {
    return DialogTheme(
      backgroundColor: colorScheme.surface,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: AppTextStyles.headlineSmall.copyWith(
        color: colorScheme.onSurface,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: colorScheme.onSurface,
      ),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: colorScheme.onInverseSurface,
      ),
      actionTextColor: colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static ProgressIndicatorThemeData _buildProgressIndicatorTheme(ColorScheme colorScheme) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.primary.withOpacity(0.2),
      circularTrackColor: colorScheme.primary.withOpacity(0.2),
    );
  }
}
```

## Color System

### App Colors Definition
```dart
// app_colors.dart
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFE53E3E); // ShartFlix Red
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFFE6E6);
  static const Color onPrimaryContainer = Color(0xFF8B0000);

  // Primary Colors - Dark Theme
  static const Color primaryDark = Color(0xFFFF5757);
  static const Color onPrimaryDark = Color(0xFF000000);
  static const Color primaryContainerDark = Color(0xFF8B0000);
  static const Color onPrimaryContainerDark = Color(0xFFFFE6E6);

  // Secondary Colors
  static const Color secondary = Color(0xFF6B46C1); // Purple
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFEDE9FE);
  static const Color onSecondaryContainer = Color(0xFF4C1D95);

  // Secondary Colors - Dark Theme
  static const Color secondaryDark = Color(0xFF8B5CF6);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color secondaryContainerDark = Color(0xFF4C1D95);
  static const Color onSecondaryContainerDark = Color(0xFFEDE9FE);

  // Tertiary Colors
  static const Color tertiary = Color(0xFF059669); // Green
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFD1FAE5);
  static const Color onTertiaryContainer = Color(0xFF064E3B);

  // Tertiary Colors - Dark Theme
  static const Color tertiaryDark = Color(0xFF10B981);
  static const Color onTertiaryDark = Color(0xFF000000);
  static const Color tertiaryContainerDark = Color(0xFF064E3B);
  static const Color onTertiaryContainerDark = Color(0xFFD1FAE5);

  // Error Colors
  static const Color error = Color(0xFFDC2626);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF7F1D1D);

  // Error Colors - Dark Theme
  static const Color errorDark = Color(0xFFEF4444);
  static const Color onErrorDark = Color(0xFF000000);
  static const Color errorContainerDark = Color(0xFF7F1D1D);
  static const Color onErrorContainerDark = Color(0xFFFEE2E2);

  // Surface Colors - Light Theme
  static const Color lightSurface = Color(0xFFFFFBFE);
  static const Color onLightSurface = Color(0xFF1C1B1F);
  static const Color lightSurfaceVariant = Color(0xFFF4F4F4);
  static const Color onLightSurfaceVariant = Color(0xFF49454F);
  static const Color lightBackground = Color(0xFFFFFBFE);
  static const Color onLightBackground = Color(0xFF1C1B1F);
  static const Color lightOutline = Color(0xFF79747E);

  // Surface Colors - Dark Theme
  static const Color darkSurface = Color(0xFF1C1B1F);
  static const Color onDarkSurface = Color(0xFFE6E1E5);
  static const Color darkSurfaceVariant = Color(0xFF2B2930);
  static const Color onDarkSurfaceVariant = Color(0xFFCAC4D0);
  static const Color darkBackground = Color(0xFF121212);
  static const Color onDarkBackground = Color(0xFFE6E1E5);
  static const Color darkOutline = Color(0xFF938F99);

  // Additional Colors
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  // Gradient Colors
  static const Color redGradientStart = Color(0xFFFF6B6B);
  static const Color redGradientEnd = Color(0xFFE53E3E);
  static const Color purpleGradientStart = Color(0xFF8B5CF6);
  static const Color purpleGradientEnd = Color(0xFF6B46C1);
  static const Color blueGradientStart = Color(0xFF60A5FA);
  static const Color blueGradientEnd = Color(0xFF3B82F6);

  // Semantic Colors
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Overlay Colors
  static const Color overlayLight = Color(0x80000000);
  static const Color overlayDark = Color(0x80FFFFFF);

  // Movie Card Colors
  static const Color movieCardShadow = Color(0x1A000000);
  static const Color favoriteActive = Color(0xFFE53E3E);
  static const Color favoriteInactive = Color(0xFF9CA3AF);
}
```

### Text Styles
```dart
// app_text_styles.dart
class AppTextStyles {
  static const String fontFamily = 'Inter';

  // Display Styles
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.22,
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.50,
    letterSpacing: 0.15,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
  );
}
```

## Theme Management BLoC

### Theme BLoC Implementation
```dart
// theme_bloc.dart
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;

  ThemeBloc({required this.themeRepository}) : super(ThemeInitial()) {
    on<ThemeLoadRequested>(_onThemeLoadRequested);
    on<ThemeChanged>(_onThemeChanged);
    on<SystemThemeChanged>(_onSystemThemeChanged);
  }

  Future<void> _onThemeLoadRequested(
    ThemeLoadRequested event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final themeMode = await themeRepository.getThemeMode();
      final useSystemTheme = await themeRepository.getUseSystemTheme();
      
      emit(ThemeLoaded(
        themeMode: themeMode,
        useSystemTheme: useSystemTheme,
      ));
    } catch (e) {
      emit(ThemeLoaded(
        themeMode: ThemeMode.system,
        useSystemTheme: true,
      ));
    }
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    final currentState = state;
    if (currentState is ThemeLoaded) {
      emit(currentState.copyWith(
        themeMode: event.themeMode,
        useSystemTheme: event.useSystemTheme,
      ));

      // Persist theme preference
      await themeRepository.saveThemeMode(event.themeMode);
      await themeRepository.saveUseSystemTheme(event.useSystemTheme);

      // Track theme change
      AnalyticsService.trackThemeChange(
        themeMode: event.themeMode.name,
        useSystemTheme: event.useSystemTheme,
      );
    }
  }

  Future<void> _onSystemThemeChanged(
    SystemThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    final currentState = state;
    if (currentState is ThemeLoaded && currentState.useSystemTheme) {
      // Update theme based on system preference
      final systemThemeMode = event.isDark ? ThemeMode.dark : ThemeMode.light;
      emit(currentState.copyWith(themeMode: systemThemeMode));
    }
  }
}

// Theme States
abstract class ThemeState {}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;
  final bool useSystemTheme;

  ThemeLoaded({
    required this.themeMode,
    required this.useSystemTheme,
  });

  ThemeLoaded copyWith({
    ThemeMode? themeMode,
    bool? useSystemTheme,
  }) {
    return ThemeLoaded(
      themeMode: themeMode ?? this.themeMode,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
    );
  }
}

// Theme Events
abstract class ThemeEvent {}

class ThemeLoadRequested extends ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final ThemeMode themeMode;
  final bool useSystemTheme;

  ThemeChanged({
    required this.themeMode,
    required this.useSystemTheme,
  });
}

class SystemThemeChanged extends ThemeEvent {
  final bool isDark;

  SystemThemeChanged({required this.isDark});
}
```

## Theme Repository

### Theme Persistence
```dart
// theme_repository.dart
class ThemeRepository {
  final LocalStorageService localStorageService;
  
  static const String _themeModeKey = 'theme_mode';
  static const String _useSystemThemeKey = 'use_system_theme';

  ThemeRepository({required this.localStorageService});

  Future<ThemeMode> getThemeMode() async {
    final themeModeString = await localStorageService.getString(_themeModeKey);
    return _stringToThemeMode(themeModeString);
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await localStorageService.set(_themeModeKey, themeMode.name);
  }

  Future<bool> getUseSystemTheme() async {
    final useSystemTheme = await localStorageService.getBool(_useSystemThemeKey);
    return useSystemTheme ?? true;
  }

  Future<void> saveUseSystemTheme(bool useSystemTheme) async {
    await localStorageService.set(_useSystemThemeKey, useSystemTheme);
  }

  ThemeMode _stringToThemeMode(String? themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
```

## Theme Widgets

### Theme Toggle Widget
```dart
// theme_toggle_widget.dart
class ThemeToggleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        if (state is! ThemeLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tema Ayarları',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            // System Theme Toggle
            SwitchListTile(
              title: const Text('Sistem Teması Kullan'),
              subtitle: const Text('Cihazınızın tema ayarını takip eder'),
              value: state.useSystemTheme,
              onChanged: (value) {
                context.read<ThemeBloc>().add(ThemeChanged(
                  themeMode: value ? ThemeMode.system : ThemeMode.light,
                  useSystemTheme: value,
                ));
              },
            ),
            
            // Manual Theme Selection
            if (!state.useSystemTheme) ...[
              const SizedBox(height: 8),
              _buildThemeOptions(context, state.themeMode),
            ],
          ],
        );
      },
    );
  }

  Widget _buildThemeOptions(BuildContext context, ThemeMode currentMode) {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('Açık Tema'),
          subtitle: const Text('Parlak renkler ve açık arka plan'),
          value: ThemeMode.light,
          groupValue: currentMode,
          onChanged: (mode) {
            if (mode != null) {
              context.read<ThemeBloc>().add(ThemeChanged(
                themeMode: mode,
                useSystemTheme: false,
              ));
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Koyu Tema'),
          subtitle: const Text('Göz dostu koyu renkler'),
          value: ThemeMode.dark,
          groupValue: currentMode,
          onChanged: (mode) {
            if (mode != null) {
              context.read<ThemeBloc>().add(ThemeChanged(
                themeMode: mode,
                useSystemTheme: false,
              ));
            }
          },
        ),
      ],
    );
  }
}
```

### Themed Widget Extensions
```dart
// theme_extensions.dart
extension ThemeDataExtensions on ThemeData {
  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;
  
  Color get movieCardBackground => isDark 
      ? AppColors.darkSurfaceVariant 
      : AppColors.lightSurface;
  
  Color get gradientOverlay => isDark 
      ? AppColors.overlayDark 
      : AppColors.overlayLight;
}

extension BuildContextThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  bool get isDarkMode => theme.isDark;
  bool get isLightMode => theme.isLight;
}

// Themed Icon Widget
class ThemedIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  const ThemedIcon(
    this.icon, {
    this.size,
    this.color,
    this.semanticLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? 24,
      color: color ?? context.colorScheme.onSurface,
      semanticLabel: semanticLabel,
    );
  }
}

// Themed Container Widget
class ThemedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const ThemedContainer({
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colorScheme.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: border,
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: context.isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
```

## Theme Animations

### Theme Transition Animation
```dart
// theme_transition.dart
class ThemeTransition extends StatefulWidget {
  final Widget child;
  final ThemeData theme;
  final Duration duration;

  const ThemeTransition({
    required this.child,
    required this.theme,
    this.duration = const Duration(milliseconds: 300),
    Key? key,
  }) : super(key: key);

  @override
  State<ThemeTransition> createState() => _ThemeTransitionState();
}

class _ThemeTransitionState extends State<ThemeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  ThemeData? _oldTheme;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(ThemeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.theme != widget.theme) {
      _oldTheme = oldWidget.theme;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (_oldTheme == null || _animation.value == 1.0) {
          return Theme(
            data: widget.theme,
            child: widget.child,
          );
        }

        return Theme(
          data: ThemeData.lerp(_oldTheme!, widget.theme, _animation.value)!,
          child: widget.child,
        );
      },
    );
  }
}
```

## Testing Theme System

### Theme Testing Utilities
```dart
// theme_test_helper.dart
class ThemeTestHelper {
  static Widget createThemedTestWidget({
    required Widget child,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: child,
    );
  }

  static void testThemeColors(WidgetTester tester, ThemeMode themeMode) {
    // Test that theme colors are applied correctly
    final theme = themeMode == ThemeMode.dark 
        ? AppTheme.darkTheme 
        : AppTheme.lightTheme;
    
    expect(theme.colorScheme.primary, equals(
      themeMode == ThemeMode.dark 
          ? AppColors.primaryDark 
          : AppColors.primary
    ));
  }
}

// Example theme test
group('Theme System Tests', () {
  testWidgets('should apply light theme correctly', (tester) async {
    await tester.pumpWidget(
      ThemeTestHelper.createThemedTestWidget(
        child: const Scaffold(body: Text('Test')),
        themeMode: ThemeMode.light,
      ),
    );

    final theme = Theme.of(tester.element(find.text('Test')));
    expect(theme.brightness, equals(Brightness.light));
    expect(theme.colorScheme.primary, equals(AppColors.primary));
  });

  testWidgets('should apply dark theme correctly', (tester) async {
    await tester.pumpWidget(
      ThemeTestHelper.createThemedTestWidget(
        child: const Scaffold(body: Text('Test')),
        themeMode: ThemeMode.dark,
      ),
    );

    final theme = Theme.of(tester.element(find.text('Test')));
    expect(theme.brightness, equals(Brightness.dark));
    expect(theme.colorScheme.primary, equals(AppColors.primaryDark));
  });
});
```

This comprehensive theme system documentation provides a solid foundation for implementing consistent theming throughout the ShartFlix application with support for both light and dark modes, custom color schemes, and smooth theme transitions. 