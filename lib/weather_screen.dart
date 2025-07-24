import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_track/scerets.dart';
import 'hourly_forecast_item.dart';
import 'additional_info_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isRefreshing = false;
  bool _is3DTouchActive = false;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<void> getCurrentWeather() async {
    String cityName = 'Lahore';
    final res = await http.get(
      Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName,pk&APPID=$openWetherAPIKey',
      ),
    );
    print(res.body);
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  void _handle3DTouch(bool active) {
    setState(() => _is3DTouchActive = active);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.deepPurple.shade800,
        actions: [
          IconButton(
            icon:
                _isRefreshing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isRefreshing ? null : _refreshData,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A0033), Color(0xFF330066)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Lahore',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => HapticFeedback.lightImpact(),
                  onLongPress: () => HapticFeedback.heavyImpact(),
                  onLongPressStart: (_) => _handle3DTouch(true),
                  onLongPressEnd: (_) => _handle3DTouch(false),
                  child: AnimatedScale(
                    scale: _is3DTouchActive ? 0.95 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4B0082), Color(0xFF800080)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.purpleAccent.withOpacity(0.3),
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.6),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const BoxedIcon(
                              WeatherIcons.day_sunny,
                              size: 72,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: const Text(
                              '36°C',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sunny',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Today, 3:45 PM',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Feels like 38°C',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Weather Forecast'),
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
                _buildSectionTitle('Additional Information'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
