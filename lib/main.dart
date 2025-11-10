import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_track/views/weather_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather UI',
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme:
            GoogleFonts.poppinsTextTheme(), // Use Poppins font as in screenshot
        scaffoldBackgroundColor: const Color(
          0xFF87CEFA,
        ), // Light blue gradient start
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4682B4), // Deep blue for AppBar
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: Colors.white.withOpacity(0.15), // Transparent cards as in UI
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      home: const WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
