import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_icons/weather_icons.dart';
import 'hourly_forecast_item.dart';
import 'additional_info_item.dart';

class WeatherScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const WeatherScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  Future<void> _handleWeatherCardPress() async {
    await HapticFeedback.mediumImpact();
    // You could add additional functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              HapticFeedback.lightImpact();
              onToggleTheme();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),

              // 🌆 City Name
              Center(
                child: Text(
                  'Lahore',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🌤 Main Weather Card with 3D Touch
              GestureDetector(
                onTap: _handleWeatherCardPress,
                onLongPress: () async {
                  await HapticFeedback.heavyImpact();
                  // Add long press functionality
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()..scale(1.0),
                    transformAlignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              isDarkMode
                                  ? [
                                    Colors.deepPurple.shade700,
                                    Colors.deepPurple.shade400,
                                  ]
                                  : [
                                    Colors.blue.shade300,
                                    Colors.blue.shade100,
                                  ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(4, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const BoxedIcon(
                            WeatherIcons.day_sunny,
                            size: 64,
                            color: Colors.amber,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '36°C',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sunny',
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  isDarkMode
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🌡️ Feels Like Text
              const Text(
                'Feels like 38°C',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),

              const SizedBox(height: 32),

              // 🔮 Weather Forecast Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Weather Forecast',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // 🕓 Hourly Forecast Row
              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    HourlyForecastItem(
                      time: '6 AM',
                      icon: WeatherIcons.night_clear,
                      temperature: '24°C',
                    ),
                    HourlyForecastItem(
                      time: '9 AM',
                      icon: WeatherIcons.day_sunny,
                      temperature: '28°C',
                    ),
                    HourlyForecastItem(
                      time: '12 PM',
                      icon: WeatherIcons.day_sunny,
                      temperature: '32°C',
                    ),
                    HourlyForecastItem(
                      time: '3 PM',
                      icon: WeatherIcons.day_sunny,
                      temperature: '35°C',
                    ),
                    HourlyForecastItem(
                      time: '6 PM',
                      icon: WeatherIcons.day_cloudy,
                      temperature: '33°C',
                    ),
                    HourlyForecastItem(
                      time: '9 PM',
                      icon: WeatherIcons.night_clear,
                      temperature: '29°C',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ℹ️ Additional Information Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // 💧 Additional Info Row (3D styled items)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: '82%',
                  ),
                  AdditionalInfoItem(
                    icon: Icons.air,
                    label: 'Wind',
                    value: '14 km/h',
                  ),
                  AdditionalInfoItem(
                    icon: Icons.speed,
                    label: 'Pressure',
                    value: '1012 hPa',
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
