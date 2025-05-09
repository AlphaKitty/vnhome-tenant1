import 'package:flutter/material.dart';
import '../design_tokens.dart';

/// 应用主题管理类
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: DesignTokens.primaryColor,
      secondary: DesignTokens.secondaryColor,
      error: DesignTokens.errorColor,
      surface: DesignTokens.cardBackgroundColor,
      onPrimary: Colors.white,
      onSecondary: DesignTokens.primaryColor,
      onSurface: DesignTokens.textColor,
    ),
    scaffoldBackgroundColor: DesignTokens.backgroundColor,
    cardColor: DesignTokens.cardBackgroundColor,
    dividerColor: DesignTokens.borderColor,
    appBarTheme: AppBarTheme(
      backgroundColor: DesignTokens.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: DesignTokens.fontSizeXXLarge,
        fontWeight: FontWeight.bold,
        color: DesignTokens.textColor,
      ),
      displayMedium: TextStyle(
        fontSize: DesignTokens.fontSizeXLarge,
        fontWeight: FontWeight.bold,
        color: DesignTokens.textColor,
      ),
      displaySmall: TextStyle(
        fontSize: DesignTokens.fontSizeLarge,
        fontWeight: FontWeight.bold,
        color: DesignTokens.textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: DesignTokens.fontSizeMedium,
        color: DesignTokens.textColor,
        height: DesignTokens.lineHeightNormal,
      ),
      bodyMedium: TextStyle(
        fontSize: DesignTokens.fontSizeSmall,
        color: DesignTokens.textColor,
        height: DesignTokens.lineHeightNormal,
      ),
      bodySmall: TextStyle(
        fontSize: DesignTokens.fontSizeXSmall,
        color: DesignTokens.textColor.withOpacity(0.8),
        height: DesignTokens.lineHeightNormal,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DesignTokens.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLarge,
          vertical: DesignTokens.spacingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DesignTokens.primaryColor,
        side: BorderSide(color: DesignTokens.primaryColor),
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLarge,
          vertical: DesignTokens.spacingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
        borderSide: BorderSide(color: DesignTokens.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
        borderSide: BorderSide(color: DesignTokens.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
        borderSide: BorderSide(color: DesignTokens.primaryColor, width: 2),
      ),
      contentPadding: EdgeInsets.all(DesignTokens.spacingMedium),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DesignTokens.backgroundColor,
      selectedItemColor: DesignTokens.primaryColor,
      unselectedItemColor: DesignTokens.textColor.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardTheme(
      color: DesignTokens.cardBackgroundColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
      ),
      margin: EdgeInsets.all(DesignTokens.spacingSmall),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: DesignTokens.darkPrimaryColor,
      secondary: DesignTokens.darkSecondaryColor,
      error: DesignTokens.errorColor,
      surface: DesignTokens.darkCardBackgroundColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: DesignTokens.darkTextColor,
    ),
    scaffoldBackgroundColor: DesignTokens.darkBackgroundColor,
    cardColor: DesignTokens.darkCardBackgroundColor,
    dividerColor: DesignTokens.darkBorderColor,
    appBarTheme: AppBarTheme(
      backgroundColor: DesignTokens.darkPrimaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: DesignTokens.fontSizeXXLarge,
        fontWeight: FontWeight.bold,
        color: DesignTokens.darkTextColor,
      ),
      displayMedium: TextStyle(
        fontSize: DesignTokens.fontSizeXLarge,
        fontWeight: FontWeight.bold,
        color: DesignTokens.darkTextColor,
      ),
      displaySmall: TextStyle(
        fontSize: DesignTokens.fontSizeLarge,
        fontWeight: FontWeight.bold,
        color: DesignTokens.darkTextColor,
      ),
      bodyLarge: TextStyle(
        fontSize: DesignTokens.fontSizeMedium,
        color: DesignTokens.darkTextColor,
        height: DesignTokens.lineHeightNormal,
      ),
      bodyMedium: TextStyle(
        fontSize: DesignTokens.fontSizeSmall,
        color: DesignTokens.darkTextColor,
        height: DesignTokens.lineHeightNormal,
      ),
      bodySmall: TextStyle(
        fontSize: DesignTokens.fontSizeXSmall,
        color: DesignTokens.darkTextColor.withOpacity(0.8),
        height: DesignTokens.lineHeightNormal,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DesignTokens.darkPrimaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLarge,
          vertical: DesignTokens.spacingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DesignTokens.darkPrimaryColor,
        side: BorderSide(color: DesignTokens.darkPrimaryColor),
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLarge,
          vertical: DesignTokens.spacingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.darkCardBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
        borderSide: BorderSide(color: DesignTokens.darkBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
        borderSide: BorderSide(color: DesignTokens.darkBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
        borderSide: BorderSide(color: DesignTokens.darkPrimaryColor, width: 2),
      ),
      contentPadding: EdgeInsets.all(DesignTokens.spacingMedium),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DesignTokens.darkBackgroundColor,
      selectedItemColor: DesignTokens.darkPrimaryColor,
      unselectedItemColor: DesignTokens.darkTextColor.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardTheme(
      color: DesignTokens.darkCardBackgroundColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(DesignTokens.circularRadiusMedium),
      ),
      margin: EdgeInsets.all(DesignTokens.spacingSmall),
    ),
  );
}
