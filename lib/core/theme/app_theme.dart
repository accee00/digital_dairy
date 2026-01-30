import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Clean, modern app theme with friendly aesthetics.
class AppTheme {
  // ═══════════════════════════════════════════════════════════════════════════
  // MODERN COLOR PALETTE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary - Modern Indigo Blue
  static const Color primary = Color(0xFF6366F1);

  /// Primary Light - Softer variant
  static const Color primaryLight = Color(0xFF818CF8);

  /// Primary Dark - Deeper variant
  static const Color primaryDark = Color(0xFF4F46E5);

  /// Secondary - Warm Coral Pink
  static const Color secondary = Color(0xFFF472B6);

  /// Accent - Fresh Cyan
  static const Color accent = Color(0xFF22D3EE);

  /// Success - Soft Green
  static const Color success = Color(0xFF10B981);

  /// Warning - Warm Amber
  static const Color warning = Color(0xFFFBBF24);

  /// Error - Soft Red
  static const Color error = Color(0xFFEF4444);

  /// Info - Sky Blue
  static const Color info = Color(0xFF3B82F6);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT MODE SURFACES
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color _lightBg = Color(0xFFFAFAFC);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightSurfaceAlt = Color(0xFFF4F4F7);
  static const Color _lightBorder = Color(0xFFE5E5EA);
  static const Color _lightBorderSubtle = Color(0xFFF0F0F3);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT MODE TEXT
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color _lightTextPrimary = Color(0xFF18181B);
  static const Color _lightTextSecondary = Color(0xFF71717A);
  static const Color _lightTextTertiary = Color(0xFFA1A1AA);

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK MODE SURFACES
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color _darkBg = Color(0xFF09090B);
  static const Color _darkSurface = Color(0xFF18181B);
  static const Color _darkSurfaceAlt = Color(0xFF27272A);
  static const Color _darkBorder = Color(0xFF3F3F46);
  static const Color _darkBorderSubtle = Color(0xFF27272A);

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK MODE TEXT
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color _darkTextPrimary = Color(0xFFFAFAFA);
  static const Color _darkTextSecondary = Color(0xFFA1A1AA);
  static const Color _darkTextTertiary = Color(0xFF71717A);

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════

  static const List<Color> primaryGradient = <Color>[
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFFA855F7),
  ];

  static const List<Color> warmGradient = <Color>[
    Color(0xFFF472B6),
    Color(0xFFFB7185),
    Color(0xFFFDA4AF),
  ];

  static const List<Color> coolGradient = <Color>[
    Color(0xFF22D3EE),
    Color(0xFF38BDF8),
    Color(0xFF60A5FA),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.light(
      primary: primary,
      primaryContainer: primary.withAlpha(25),
      onPrimaryContainer: primaryDark,
      secondary: secondary,
      secondaryContainer: secondary.withAlpha(25),
      onSecondaryContainer: Color(0xFFBE185D),
      tertiary: accent,
      tertiaryContainer: accent.withAlpha(25),
      surface: _lightSurface,
      surfaceContainerHighest: _lightSurfaceAlt,
      onSurface: _lightTextPrimary,
      onSurfaceVariant: _lightTextSecondary,
      outline: _lightBorder,
      outlineVariant: _lightBorderSubtle,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _lightBg,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: _lightBg,
        surfaceTintColor: Colors.transparent,
        foregroundColor: _lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: _lightTextPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: _lightTextPrimary, size: 22),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightTextPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: const BorderSide(color: _lightBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        extendedTextStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _lightBorderSubtle),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurfaceAlt,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: _lightTextTertiary, fontSize: 15),
        labelStyle: GoogleFonts.inter(color: _lightTextSecondary, fontSize: 15),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: _lightSurfaceAlt,
        selectedColor: primary.withAlpha(30),
        labelStyle: GoogleFonts.inter(
          color: _lightTextPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Bottom Nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _lightSurface,
        selectedItemColor: primary,
        unselectedItemColor: _lightTextTertiary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _lightSurface,
        indicatorColor: primary.withAlpha(25),
        elevation: 0,
        height: 65,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _lightTextTertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary, size: 24);
          }
          return const IconThemeData(color: _lightTextTertiary, size: 24);
        }),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: _lightSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.inter(
          color: _lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: GoogleFonts.inter(
          color: _lightTextSecondary,
          fontSize: 15,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _lightSurface,
        modalBackgroundColor: _lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        showDragHandle: true,
        dragHandleColor: _lightBorder,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: _lightBorderSubtle,
        thickness: 1,
        space: 1,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: GoogleFonts.inter(
          color: _lightTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          color: _lightTextSecondary,
          fontSize: 14,
        ),
      ),

      // Snackbars
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _lightTextPrimary,
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),

      // Progress
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: _lightSurfaceAlt,
        circularTrackColor: _lightSurfaceAlt,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return _lightTextTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return _lightBorder;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Text Theme
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          displayLarge: GoogleFonts.inter(
            color: _lightTextPrimary,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
          displayMedium: GoogleFonts.inter(
            color: _lightTextPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          displaySmall: GoogleFonts.inter(
            color: _lightTextPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          headlineLarge: GoogleFonts.inter(
            color: _lightTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: GoogleFonts.inter(
            color: _lightTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: GoogleFonts.inter(
            color: _lightTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: GoogleFonts.inter(
            color: _lightTextPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: GoogleFonts.inter(
            color: _lightTextPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: GoogleFonts.inter(
            color: _lightTextSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: GoogleFonts.inter(
            color: _lightTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: GoogleFonts.inter(
            color: _lightTextPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: GoogleFonts.inter(
            color: _lightTextSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: GoogleFonts.inter(
            color: _lightTextSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: GoogleFonts.inter(
            color: _lightTextTertiary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      iconTheme: const IconThemeData(color: _lightTextSecondary, size: 24),
      primaryIconTheme: const IconThemeData(color: Colors.white, size: 24),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.dark(
      primary: primaryLight,
      primaryContainer: primary.withAlpha(40),
      onPrimaryContainer: Color(0xFFE0E7FF),
      secondary: secondary,
      secondaryContainer: secondary.withAlpha(40),
      onSecondaryContainer: Color(0xFFFCE7F3),
      tertiary: accent,
      tertiaryContainer: accent.withAlpha(40),
      surface: _darkSurface,
      surfaceContainerHighest: _darkSurfaceAlt,
      onSurface: _darkTextPrimary,
      onSurfaceVariant: _darkTextSecondary,
      outline: _darkBorder,
      outlineVariant: _darkBorderSubtle,
      error: Color(0xFFFCA5A5),
      onPrimary: Color(0xFF1E1B4B),
      onSecondary: Color(0xFF831843),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _darkBg,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: _darkBg,
        surfaceTintColor: Colors.transparent,
        foregroundColor: _darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: _darkTextPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: _darkTextPrimary, size: 22),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Color(0xFF1E1B4B),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Color(0xFF1E1B4B),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkTextPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: const BorderSide(color: _darkBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: Color(0xFF1E1B4B),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        extendedTextStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _darkBorderSubtle),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurfaceAlt,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
          borderSide: const BorderSide(color: primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFCA5A5)),
        ),
        hintStyle: GoogleFonts.inter(color: _darkTextTertiary, fontSize: 15),
        labelStyle: GoogleFonts.inter(color: _darkTextSecondary, fontSize: 15),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: _darkSurfaceAlt,
        selectedColor: primaryLight.withAlpha(40),
        labelStyle: GoogleFonts.inter(
          color: _darkTextPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Bottom Nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: primaryLight,
        unselectedItemColor: _darkTextTertiary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkSurface,
        indicatorColor: primaryLight.withAlpha(30),
        elevation: 0,
        height: 65,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryLight,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _darkTextTertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryLight, size: 24);
          }
          return const IconThemeData(color: _darkTextTertiary, size: 24);
        }),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: _darkSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.inter(
          color: _darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: GoogleFonts.inter(
          color: _darkTextSecondary,
          fontSize: 15,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _darkSurface,
        modalBackgroundColor: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        showDragHandle: true,
        dragHandleColor: _darkBorder,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: _darkBorderSubtle,
        thickness: 1,
        space: 1,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: GoogleFonts.inter(
          color: _darkTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          color: _darkTextSecondary,
          fontSize: 14,
        ),
      ),

      // Snackbars
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _darkSurfaceAlt,
        contentTextStyle: GoogleFonts.inter(
          color: _darkTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),

      // Progress
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryLight,
        linearTrackColor: _darkSurfaceAlt,
        circularTrackColor: _darkSurfaceAlt,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xFF1E1B4B);
          }
          return _darkTextTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryLight;
          }
          return _darkBorder;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Text Theme
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          displayLarge: GoogleFonts.inter(
            color: _darkTextPrimary,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
          displayMedium: GoogleFonts.inter(
            color: _darkTextPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          displaySmall: GoogleFonts.inter(
            color: _darkTextPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
          headlineLarge: GoogleFonts.inter(
            color: _darkTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: GoogleFonts.inter(
            color: _darkTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: GoogleFonts.inter(
            color: _darkTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: GoogleFonts.inter(
            color: _darkTextPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: GoogleFonts.inter(
            color: _darkTextPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: GoogleFonts.inter(
            color: _darkTextSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: GoogleFonts.inter(
            color: _darkTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: GoogleFonts.inter(
            color: _darkTextPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: GoogleFonts.inter(
            color: _darkTextSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: GoogleFonts.inter(
            color: Color(0xFF1E1B4B),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: GoogleFonts.inter(
            color: _darkTextSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: GoogleFonts.inter(
            color: _darkTextTertiary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      iconTheme: const IconThemeData(color: _darkTextSecondary, size: 24),
      primaryIconTheme: const IconThemeData(color: Color(0xFF1E1B4B), size: 24),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Soft shadow for cards
  static List<BoxShadow> get softShadow => <BoxShadow>[
    BoxShadow(
      color: Colors.black.withAlpha(8),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// Elevated shadow
  static List<BoxShadow> get elevatedShadow => <BoxShadow>[
    BoxShadow(
      color: Colors.black.withAlpha(12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  /// Primary colored glow
  static List<BoxShadow> get primaryGlow => <BoxShadow>[
    BoxShadow(
      color: primary.withAlpha(40),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];
}
