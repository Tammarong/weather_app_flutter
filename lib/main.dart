import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/presentation/ui/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = FlexColorScheme.light(
      scheme: FlexScheme.wasabi,
    ).toTheme;
    const inkColor = Color(0xFF25301F);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFFF5F7EF),
        appBarTheme: baseTheme.appBarTheme.copyWith(
          backgroundColor: Colors.transparent,
          foregroundColor: inkColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        textTheme: baseTheme.textTheme
            .apply(bodyColor: inkColor, displayColor: inkColor)
            .copyWith(
              displayLarge: baseTheme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
              ),
              headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.7,
              ),
              titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
