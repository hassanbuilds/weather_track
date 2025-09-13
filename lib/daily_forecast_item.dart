import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class DailyForecastItem extends StatelessWidget {
  final String day;
  final int lowTemp;
  final int highTemp;
  final IconData icon;

  const DailyForecastItem({
    super.key,
    required this.day,
    required this.lowTemp,
    required this.highTemp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white30, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          BoxedIcon(icon, color: Colors.yellowAccent, size: 24),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$highTemp°',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  '$lowTemp°',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
