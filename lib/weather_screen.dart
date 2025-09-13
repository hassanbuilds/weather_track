import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_track/scerets.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'daily_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isRefreshing = false;
  Map<String, dynamic>? currentWeather;
  List<dynamic> hourlyForecast = [];
  List<dynamic> dailyForecast = [];

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  List<Map<String, dynamic>> _getNextSevenDays() {
    // Create a list of 7 days of the week
    List<String> dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    // Temperature data
    List<int> lowTemps = [59, 59, 59, 63, 65, 67, 69];
    List<int> highTemps = [85, 91, 95, 93, 91, 89, 87];

    List<Map<String, dynamic>> days = [];
    for (int i = 0; i < 7; i++) {
      days.add({
        'day': dayNames[i],
        'low': lowTemps[i],
        'high': highTemps[i],
        'icon': '01d',
      });
    }

    return days;
  }

  Future<void> getWeatherData() async {
    const cityName = 'Cupertino';
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,us&appid=$openWeatherApiKey&units=metric',
    );

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        debugPrint("API Response: ${data.toString()}");

        setState(() {
          currentWeather = data['list'][0];
          hourlyForecast = data['list'].sublist(0, 6);

          // Get 7 days for the forecast
          dailyForecast = _getNextSevenDays();
        });
      } else {
        debugPrint("Error fetching weather: Status Code ${res.statusCode}");
        debugPrint("Response body: ${res.body}");

        // Set fallback data if API fails
        setState(() {
          currentWeather = {
            'main': {
              'temp': 72,
              'temp_max': 87,
              'temp_min': 61,
              'humidity': 45,
              'pressure': 1013,
            },
            'weather': [
              {'description': 'sunny', 'icon': '01d'},
            ],
            'wind': {'speed': 3.3},
          };
          hourlyForecast = List.generate(
            6,
            (index) => {
              'dt_txt': '2023-01-01 ${10 + index}:00:00',
              'main': {'temp': 72 + index * 2},
              'weather': [
                {'icon': '01d'},
              ],
            },
          );

          // Get 7 days for the forecast
          dailyForecast = _getNextSevenDays();
        });
      }
    } catch (e) {
      debugPrint("Exception fetching weather: $e");

      // Set fallback data if exception occurs
      setState(() {
        currentWeather = {
          'main': {
            'temp': 72,
            'temp_max': 87,
            'temp_min': 61,
            'humidity': 45,
            'pressure': 1013,
          },
          'weather': [
            {'description': 'sunny', 'icon': '01d'},
          ],
          'wind': {'speed': 3.3},
        };
        hourlyForecast = List.generate(
          6,
          (index) => {
            'dt_txt': '2023-01-01 ${10 + index}:00:00',
            'main': {'temp': 72 + index * 2},
            'weather': [
              {'icon': '01d'},
            ],
          },
        );

        // Get 7 days for the forecast
        dailyForecast = _getNextSevenDays();
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    await HapticFeedback.lightImpact();
    await getWeatherData();
    setState(() => _isRefreshing = false);
  }

  IconData mapWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return WeatherIcons.day_sunny;
      case '01n':
        return WeatherIcons.night_clear;
      case '02d':
        return WeatherIcons.day_cloudy;
      case '02n':
        return WeatherIcons.night_alt_cloudy;
      case '03d':
      case '03n':
        return WeatherIcons.cloud;
      case '04d':
      case '04n':
        return WeatherIcons.cloudy;
      case '09d':
      case '09n':
        return WeatherIcons.showers;
      case '10d':
        return WeatherIcons.day_rain;
      case '10n':
        return WeatherIcons.night_alt_rain;
      case '11d':
      case '11n':
        return WeatherIcons.thunderstorm;
      case '13d':
      case '13n':
        return WeatherIcons.snow;
      case '50d':
      case '50n':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.na;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator if data is not loaded yet
    if (currentWeather == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5B8CFF), Color(0xFF77B5FE)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    final temp = currentWeather?['main']?['temp']?.round();
    final description = currentWeather?['weather']?[0]?['description'] ?? '';
    final iconCode = currentWeather?['weather']?[0]?['icon'] ?? '';
    final highTemp = currentWeather?['main']?['temp_max']?.round();
    final lowTemp = currentWeather?['main']?['temp_min']?.round();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Weather'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5B8CFF), Color(0xFF77B5FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location
                const SizedBox(height: 10),
                const Text(
                  'MY LOCATION',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Cupertino',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Main temperature
                Center(
                  child: Text(
                    '${temp ?? '--'}°',
                    style: const TextStyle(
                      fontSize: 84,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Weather condition
                Center(
                  child: Text(
                    description.toUpperCase(),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),

                // High/Low temperatures
                Center(
                  child: Text(
                    'H:${highTemp ?? '--'}° L:${lowTemp ?? '--'}°',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),

                // Hourly forecast section with dark background - UPDATED
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 12),
                        child: Text(
                          'Sunny conditions will continue all day. Wind gusts are up to 12 km/h.',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 8),
                        child: Text(
                          'HOURLY FORECAST',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: hourlyForecast.length,
                          itemBuilder: (context, index) {
                            final forecast = hourlyForecast[index];
                            final time = forecast['dt_txt']
                                .toString()
                                .split(' ')[1]
                                .substring(0, 5);
                            final hour = int.parse(time.split(':')[0]);
                            String displayTime;

                            if (index == 0) {
                              displayTime = 'Now';
                            } else if (hour == 0) {
                              displayTime = '12AM';
                            } else if (hour < 12) {
                              displayTime = '${hour}AM';
                            } else if (hour == 12) {
                              displayTime = '12PM';
                            } else {
                              displayTime = '${hour - 12}PM';
                            }

                            final temp = forecast['main']['temp'].round();
                            final icon = mapWeatherIcon(
                              forecast['weather'][0]['icon'],
                            );

                            return HourlyForecastItem(
                              time: displayTime,
                              icon: icon,
                              temperature: '$temp°',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 7-Day Forecast section with dark background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '7-DAY FORECAST',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children:
                            dailyForecast.map((dayData) {
                              return DailyForecastItem(
                                day: dayData['day'],
                                lowTemp: dayData['low'],
                                highTemp: dayData['high'],
                                icon: mapWeatherIcon(dayData['icon']),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
