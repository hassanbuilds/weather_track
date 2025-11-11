import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  bool isRefreshing = false;
  Map<String, dynamic>? currentWeather;
  List<dynamic> hourlyForecast = [];
  List<dynamic> dailyForecast = [];

  final WeatherService _weatherService = WeatherService();

  // Fetch weather by city
  Future<void> getWeatherData({required String city}) async {
    final data = await _weatherService.fetchWeather(city: city);
    if (data != null) {
      currentWeather = data;

      hourlyForecast = List.generate(
        6,
        (index) => {
          'dt_txt': '2023-01-01 ${10 + index}:00:00',
          'main': {'temp': (data['main']['temp'] + index).round()},
          'weather': [
            {'icon': data['weather'][0]['icon']},
          ],
        },
      );

      dailyForecast = _getNextSevenDays();
    } else {
      currentWeather = {};
      hourlyForecast = [];
      dailyForecast = [];
    }
    notifyListeners();
  }

  // Fetch weather using current device location
  Future<void> getWeatherDataWithLocation(
    Future<Position?> Function() getCurrentLocation,
  ) async {
    Position? position = await getCurrentLocation();
    if (position != null) {
      final data = await _weatherService.fetchWeather(
        lat: position.latitude,
        lon: position.longitude,
      );

      if (data != null) {
        currentWeather = data;

        hourlyForecast = List.generate(
          6,
          (index) => {
            'dt_txt': '2023-01-01 ${10 + index}:00:00',
            'main': {'temp': (data['main']['temp'] + index).round()},
            'weather': [
              {'icon': data['weather'][0]['icon']},
            ],
          },
        );

        dailyForecast = _getNextSevenDays();
      } else {
        currentWeather = {};
        hourlyForecast = [];
        dailyForecast = [];
      }
      notifyListeners();
    } else {
      currentWeather = {};
      hourlyForecast = [];
      dailyForecast = [];
      notifyListeners();
    }
  }

  // Refresh current data
  Future<void> refreshData() async {
    isRefreshing = true;
    notifyListeners();

    if (currentWeather != null && currentWeather!['name'] != null) {
      await getWeatherData(city: currentWeather!['name']);
    }

    isRefreshing = false;
    notifyListeners();
  }

  // Dummy 7-day forecast
  List<Map<String, dynamic>> _getNextSevenDays() {
    List<String> dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
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
}
