// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// BUTUN ILOVA UCHUN PULT (GLOBAL)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Edu App',
          
          // --- KUNDUZGI REJIM ---
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: const Color(0xFFF5F9FF), // Ochiq fon
            useMaterial3: true,
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF5F9FF),
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // --- TUNGI REJIM (DARK) ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: const Color(0xFF121212), // Qora fon
            useMaterial3: true,
            cardColor: const Color(0xFF1E1E1E), // To'q kulrang kartalar
            dividerColor: Colors.grey[800],
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          themeMode: currentMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}