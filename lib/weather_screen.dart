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

  Future<void> getWeatherData() async {
    const cityName = 'Cupertino';
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,us&appid=$openWeatherApiKey&units=imperial',
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      setState(() {
        currentWeather = data['list'][0];
        hourlyForecast = data['list'].sublist(0, 6);

        // For demo purposes, we'll use static data as shown in the screenshot
        // In a real app, you would process the API response to get daily forecasts
        dailyForecast = [
          {'day': 'Today', 'low': 61, 'high': 87, 'icon': '01d'},
          {'day': 'Tue', 'low': 59, 'high': 85, 'icon': '01d'},
          {'day': 'Wed', 'low': 59, 'high': 91, 'icon': '01d'},
          {'day': 'Thu', 'low': 63, 'high': 95, 'icon': '01d'},
        ];
      });
    } else {
      debugPrint("Error fetching weather: ${res.body}");
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ), // Reduced vertical padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location
                const Text(
                  'MY LOCATION',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cupertino',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16), // Reduced spacing
                // Main temperature - made slightly smaller
                Center(
                  child: Text(
                    '${temp ?? '--'}°',
                    style: const TextStyle(
                      fontSize: 80, // Reduced from 90
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Reduced spacing
                // Weather condition
                Center(
                  child: Text(
                    description.toUpperCase(),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8), // Reduced spacing
                // High/Low temperatures
                Center(
                  child: Text(
                    'H:${highTemp ?? '--'}° L:${lowTemp ?? '--'}°',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16), // Reduced spacing
                // Weather description
                const Center(
                  child: Text(
                    'Sunny conditions will continue all day. Wind gusts are up to 12 km/h.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20), // Reduced spacing
                // Hourly forecast
                const Text(
                  'HOURLY FORECAST',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 110, // Reduced height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hourlyForecast.length,
                    itemBuilder: (context, index) {
                      final forecast = hourlyForecast[index];
                      final time = forecast['dt_txt']
                          .toString()
                          .split(' ')[1]
                          .substring(0, 5);
                      final hour = time.split(':')[0];
                      final displayTime =
                          index == 0
                              ? 'Now'
                              : '${int.parse(hour) % 12}${int.parse(hour) >= 12 ? 'PM' : 'AM'}';
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
                const SizedBox(height: 20),

                // 10-Day Forecast
                const Text(
                  '10-DAY FORECAST',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
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

                // Add some bottom padding to ensure everything fits
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
