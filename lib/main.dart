import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather_screen.dart';

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
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.blue.shade50, // Light blue background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade800, // Dark blue app bar
          foregroundColor: Colors.white, // White text/icons
        ),
      ),
      home: const WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
