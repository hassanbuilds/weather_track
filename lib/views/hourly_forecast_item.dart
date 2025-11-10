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
      width: 60, // Reduced from 70 to 60 for better spacing
      margin: const EdgeInsets.symmetric(horizontal: 6), // Reduced from 8 to 6
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6), // Reduced from 8 to 6
          BoxedIcon(
            icon,
            color: Colors.yellowAccent,
            size: 22,
          ), // Reduced from 24 to 22
          const SizedBox(height: 6), // Reduced from 8 to 6
          Text(
            temperature,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14, // Reduced from 16 to 14
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
