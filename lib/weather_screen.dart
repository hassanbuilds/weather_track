import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_track/scerets.dart';
import 'hourly_forecast_item.dart';
import 'additional_info_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isRefreshing = false;
  Map<String, dynamic>? currentWeather;
  List<dynamic> hourlyForecast = [];

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  Future<void> getWeatherData() async {
    const cityName = 'Lahore';
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,pk&appid=$openWeatherApiKey&units=metric',
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      setState(() {
        currentWeather = data['list'][0];
        hourlyForecast = data['list'].sublist(0, 8);
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.lightBlue.shade700,
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
            colors: [Color(0xFF87CEFA), Color(0xFF4682B4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Main weather card
                if (currentWeather != null)
                  Card(
                    color: Colors.white.withOpacity(0.15),
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 12,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Lahore',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          BoxedIcon(
                            mapWeatherIcon(iconCode),
                            size: 78,
                            color: Colors.yellowAccent,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${temp ?? '--'}°C',
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            description.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Hourly forecast card
                _buildSectionTitle('Weather Forecast'),
                const SizedBox(height: 8),
                Card(
                  color: Colors.white.withOpacity(0.15),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hourlyForecast.length,
                      itemBuilder: (context, index) {
                        final forecast = hourlyForecast[index];
                        final time = forecast['dt_txt']
                            .toString()
                            .split(' ')[1]
                            .substring(0, 5);
                        final temp = forecast['main']['temp'].round();
                        final icon = mapWeatherIcon(
                          forecast['weather'][0]['icon'],
                        );

                        return HourlyForecastItem(
                          time: time,
                          icon: icon,
                          temperature: '$temp°C',
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Additional info card
                _buildSectionTitle('Additional Information'),
                const SizedBox(height: 8),
                if (currentWeather != null)
                  Card(
                    color: Colors.black.withOpacity(0.25),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AdditionalInfoItem(
                            icon: WeatherIcons.humidity,
                            label: 'Humidity',
                            value: '${currentWeather!['main']['humidity']}%',
                          ),
                          AdditionalInfoItem(
                            icon: WeatherIcons.strong_wind,
                            label: 'Wind',
                            value: '${currentWeather!['wind']['speed']} m/s',
                          ),
                          AdditionalInfoItem(
                            icon: WeatherIcons.barometer,
                            label: 'Pressure',
                            value: '${currentWeather!['main']['pressure']} hPa',
                          ),
                        ],
                      ),
                    ),
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
