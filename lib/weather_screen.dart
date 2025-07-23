import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_track/additional_info_item.dart';
import 'package:weather_track/hourly_forecast_item.dart';

class WeatherScreeen extends StatelessWidget {
  const WeatherScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 14,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: const [
                          Text(
                            '300°K',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Icon(Icons.cloud, size: 64),
                          SizedBox(height: 16),
                          Text('Rain', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourlyForeCastItem(
                        time: '00:00',
                        icon: Icons.brightness_7,
                        temperature: '301.22',
                      ),
                      HourlyForeCastItem(
                        time: '03:00',
                        icon: Icons.sunny,
                        temperature: '300.52',
                      ),
                      HourlyForeCastItem(
                        time: '06:00',
                        icon: Icons.brightness_4,
                        temperature: '301.22',
                      ),
                      HourlyForeCastItem(
                        time: '09:00',
                        icon: Icons.brightness_2_sharp,
                        temperature: '301.22',
                      ),
                      HourlyForeCastItem(
                        time: '12:00',
                        icon: Icons.brightness_3,
                        temperature: '300.12',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '91',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '7.5',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '1000',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
