import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;

  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70, // Reduced width
      margin: const EdgeInsets.symmetric(horizontal: 6), // Reduced margin
      padding: const EdgeInsets.all(10), // Reduced padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ), // Smaller font
          ),
          const SizedBox(height: 6),
          BoxedIcon(icon, color: Colors.yellowAccent, size: 24), // Smaller icon
          const SizedBox(height: 6),
          Text(
            temperature,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ), // Smaller font
          ),
        ],
      ),
    );
  }
}
