import 'package:flutter/material.dart';

class PremiumColors {
  // Primary Colors - Deep Navy & Teal
  static const Color primaryDark = Color(0xFF0a1628);
  static const Color primaryDarker = Color(0xFF051019);
  static const Color accentGold = Color(0xFF00d9ff);
  static const Color accentGoldDark = Color(0xFF00b8d4);

  // Secondary Colors
  static const Color surfaceDark = Color(0xFF0f2438);
  static const Color surfaceLight = Color(0xFF1a3a52);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFe8f4f8);
  static const Color textSecondary = Color(0xFF9db4c4);
  static const Color textMuted = Color(0xFF5a7a8c);

  // Status Colors - Modern variants
  static const Color statusSuccess = Color(0xFF00e676);
  static const Color statusWarning = Color(0xFFffb74d);
  static const Color statusDanger = Color(0xFFef5350);
  static const Color statusInfo = Color(0xFF29b6f6);
  static const Color statusPending = Color(0xFFab47bc);

  // Background
  static const Color bgPrimary = Color(0xFF050d15);
  static const Color bgSecondary = Color(0xFF0d1b2a);
  static const Color bgTertiary = Color(0xFF132a3f);

  // Border
  static const Color borderColor = Color(0xFF1f3a52);
  static const Color borderColorLight = Color(0xFF2a4a62);
}

class PremiumTheme {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: PremiumColors.primaryDark,
      scaffoldBackgroundColor: PremiumColors.bgPrimary,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: PremiumColors.primaryDarker,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        titleTextStyle: const TextStyle(
          color: PremiumColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: PremiumColors.accentGold),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PremiumColors.primaryDarker,
        elevation: 12,
        selectedItemColor: PremiumColors.accentGold,
        unselectedItemColor: PremiumColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: PremiumColors.surfaceDark,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: PremiumColors.borderColor,
            width: 0.5,
          ),
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PremiumColors.accentGold,
          foregroundColor: PremiumColors.primaryDark,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PremiumColors.accentGold,
          side: const BorderSide(
            color: PremiumColors.accentGold,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: PremiumColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
        displayMedium: TextStyle(
          color: PremiumColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        titleLarge: TextStyle(
          color: PremiumColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        titleMedium: TextStyle(
          color: PremiumColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        titleSmall: TextStyle(
          color: PremiumColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          color: PremiumColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
        ),
        bodyMedium: TextStyle(
          color: PremiumColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        bodySmall: TextStyle(
          color: PremiumColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PremiumColors.bgSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: PremiumColors.borderColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: PremiumColors.borderColor,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: PremiumColors.accentGold,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: PremiumColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          color: PremiumColors.textMuted,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PremiumColors.accentGold,
        foregroundColor: PremiumColors.primaryDark,
        elevation: 8,
        highlightElevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: PremiumColors.surfaceDark,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: PremiumColors.borderColor,
            width: 0.5,
          ),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: PremiumColors.bgSecondary,
        selectedColor: PremiumColors.accentGold,
        secondarySelectedColor: PremiumColors.accentGoldDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        labelStyle: const TextStyle(
          color: PremiumColors.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        secondaryLabelStyle: const TextStyle(
          color: PremiumColors.primaryDark,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: PremiumColors.borderColor,
            width: 0.5,
          ),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: PremiumColors.borderColor,
        thickness: 0.5,
        space: 16,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: PremiumColors.accentGold,
        size: 24,
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PremiumColors.surfaceDark,
        contentTextStyle: const TextStyle(
          color: PremiumColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: PremiumColors.borderColor,
            width: 0.5,
          ),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: PremiumColors.accentGold,
        linearMinHeight: 4,
      ),
    );
  }
}

// Premium Gradient Utils
class PremiumGradients {
  static LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      PremiumColors.primaryDarker,
      PremiumColors.primaryDark.withOpacity(0.8),
    ],
  );

  static LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      PremiumColors.accentGold,
      PremiumColors.accentGoldDark,
    ],
  );

  static LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      PremiumColors.statusSuccess,
      PremiumColors.statusSuccess.withOpacity(0.7),
    ],
  );

  static LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      PremiumColors.statusWarning,
      PremiumColors.statusWarning.withOpacity(0.7),
    ],
  );

  static LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      PremiumColors.statusDanger,
      PremiumColors.statusDanger.withOpacity(0.7),
    ],
  );
}

// Premium Box Shadow
class PremiumShadows {
  static List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      offset: const Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  static List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      offset: const Offset(0, 4),
      blurRadius: 8,
    ),
  ];

  static List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0, 8),
      blurRadius: 12,
    ),
  ];

  static List<BoxShadow> elevationGold = [
    BoxShadow(
      color: PremiumColors.accentGold.withOpacity(0.2),
      offset: const Offset(0, 4),
      blurRadius: 12,
    ),
  ];
}
