import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///
class AppTheme {
  /// Primary Color Palette
  static const Color primary = Color(0xFF1e3c72);

  ///
  //////
  static const Color primaryVariant = Color(0xFF2a5298);

  ///
  static const Color secondary = Color(0xFF667eea);

  ///
  static const Color secondaryVariant = Color(0xFF764ba2);

  /// Additional Colors
  static const Color surface = Color(0xFFF8F9FA);

  ///
  static const Color background = Color(0xFFFFFFFF);

  ///
  static const Color error = Colors.red;

  ///
  static const Color success = Color(0xFF66BB6A);

  ///
  static const Color warning = Color(0xFFFFB74D);

  ///
  static const Color info = Color(0xFF42A5F5);

  /// Text Colors (Light)
  static const Color textPrimary = Color(0xFF1A1A1A);

  ///
  static const Color textSecondary = Color(0xFF6B7280);

  ///
  static const Color textHint = Color(0xFF9CA3AF);

  ///
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Dark Mode Colors
  static const Color darkSurface = Color(0xFF1E1E1E);

  ///
  static const Color darkBackground = Color(0xFF121212);

  ///
  static const Color darkTextPrimary = Color(0xFFE5E5E5);

  ///
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  ///
  static const Color darkTextHint = Color(0xFF707070);

  /// Gradient Colors
  static const List<Color> primaryGradient = <Color>[
    Color(0xFF1e3c72),
    Color(0xFF2a5298),
    Color(0xFF667eea),
    Color(0xFF764ba2),
  ];

  ///
  static const List<Color> lightGradient = <Color>[
    Color(0xFFf8faff),
    Color(0xFFe8f0ff),
    Color(0xFFd6e4ff),
    Color(0xFFc4d8ff),
  ];

  ///
  static const List<Color> darkGradient = <Color>[
    Color(0xFF0f1f3f),
    Color(0xFF1a2f5f),
    Color(0xFF334475),
    Color(0xFF4a3a61),
  ];

  /// Light Theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: primary,
      primaryContainer: Color(0xFFE3F2FD),
      secondary: secondary,
      secondaryContainer: Color(0xFFEDE7F6),
      surface: surface,
      error: error,
      onSecondary: textOnPrimary,
      onSurface: textPrimary,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: textOnPrimary,
        elevation: 4,
        shadowColor: primary.withAlpha(76),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: textOnPrimary,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // Text Theme
    textTheme: GoogleFonts.notoSansDevanagariTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
        ),
        displaySmall: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        titleSmall: TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          color: textOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          color: textHint,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );

  /// Dark Theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: secondary,
      primaryContainer: Color(0xFF1A237E),
      secondary: primaryVariant,
      secondaryContainer: Color(0xFF4527A0),
      surface: darkSurface,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: darkTextPrimary,
    ),

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: darkTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(color: darkTextPrimary, size: 24),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: textOnPrimary,
        elevation: 4,
        shadowColor: secondary.withAlpha(76),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondary,
      foregroundColor: textOnPrimary,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // Text Theme
    textTheme: GoogleFonts.notoSansDevanagariTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          color: darkTextPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          color: darkTextPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
        ),
        displaySmall: TextStyle(
          color: darkTextPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          color: darkTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        headlineSmall: TextStyle(
          color: darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleLarge: TextStyle(
          color: darkTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          color: darkTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        titleSmall: TextStyle(
          color: darkTextSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          color: darkTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          color: darkTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          color: darkTextSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          color: textOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          color: darkTextSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          color: darkTextHint,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: darkTextSecondary, size: 24),

    // Primary Icon Theme
    primaryIconTheme: const IconThemeData(color: textOnPrimary, size: 24),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: darkTextHint.withAlpha(55),
      thickness: 1,
      space: 24,
    ),

    // Slider Theme
    sliderTheme: const SliderThemeData(
      activeTrackColor: secondary,
      inactiveTrackColor: Color(0xFF424242),
      thumbColor: secondary,
      overlayColor: Color(0x1F667eea),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: secondary,
      linearTrackColor: Color(0xFF424242),
      circularTrackColor: Color(0xFF424242),
    ),

    // Snack Bar Theme
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF2C2C2C),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  );

  /// Glassmorphism Effect
  static BoxDecoration glassmorphism({
    double opacity = 0.1,
    double blur = 10,
    BorderRadius? borderRadius,
    bool isDark = false,
  }) {
    final int alpha = (opacity * 255).round();
    return BoxDecoration(
      color: isDark
          ? Colors.white.withAlpha(alpha ~/ 2)
          : Colors.white.withAlpha(alpha),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withAlpha(30)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withAlpha(isDark ? 51 : 25),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Custom Shadows
  static List<BoxShadow> get cardShadow => <BoxShadow>[
    BoxShadow(
      color: primary.withAlpha(25),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.black.withAlpha(13),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
}
