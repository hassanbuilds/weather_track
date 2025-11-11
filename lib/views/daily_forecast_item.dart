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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white30, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenWidth * 0.15, // responsive width for day
            child: Text(
              day,
              style: TextStyle(
                fontSize: screenWidth * 0.04, // responsive font size
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          BoxedIcon(
            icon,
            color: Colors.yellowAccent,
            size: screenWidth * 0.06,
          ), // responsive icon
          SizedBox(
            width: screenWidth * 0.35, // responsive width for temperature row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$highTemp°',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // responsive font
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02), // responsive spacing
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: screenWidth * 0.03,
                ), // responsive arrow
                SizedBox(width: screenWidth * 0.02), // responsive spacing
                Text(
                  '$lowTemp°',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
