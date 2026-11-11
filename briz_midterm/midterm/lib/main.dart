import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const CampusWellnessApp());
}

class CampusWellnessApp extends StatelessWidget {
  const CampusWellnessApp({super.key});

  static const Color wellnessGreen = Color(0xFF237A68);
  static const Color wellnessBackground = Color(0xFFF6F9F7);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: wellnessGreen,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Campus Wellness Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: wellnessBackground,
        visualDensity: VisualDensity.adaptivePlatformDensity,

        appBarTheme: AppBarTheme(
          backgroundColor: wellnessBackground,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        cardTheme: CardThemeData(
          color: colorScheme.surface,
          elevation: 1,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 54),
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 52),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(
              color: colorScheme.outlineVariant,
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: wellnessGreen,
          linearTrackColor: colorScheme.surfaceContainerHighest,
        ),

        dividerTheme: DividerThemeData(
          color: colorScheme.outlineVariant,
          thickness: 1,
        ),

        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            height: 1.45,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}