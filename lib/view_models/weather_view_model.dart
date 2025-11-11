import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  bool isRefreshing = false;
  bool isOffline = false;

  Map<String, dynamic>? currentWeather;
  List<dynamic> hourlyForecast = [];
  List<dynamic> dailyForecast = [];

  final WeatherService _weatherService = WeatherService();

  // --- Check internet connection
  Future<bool> _hasInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // --- Save weather + forecasts to cache
  Future<void> _saveCachedWeather(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_weather', jsonEncode(data));
  }

  // --- Load weather + forecasts from cache
  Future<Map<String, dynamic>?> _loadCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('cached_weather');
    if (cached != null) {
      return jsonDecode(cached);
    }
    return null;
  }

  // --- Fetch weather by city
  Future<void> getWeatherData({required String city}) async {
    final hasConnection = await _hasInternetConnection();

    if (hasConnection) {
      final data = await _weatherService.fetchWeather(city: city);
      if (data != null) {
        currentWeather = data;
        hourlyForecast = _generateHourlyForecast(data);
        dailyForecast = _getNextSevenDays();
        isOffline = false;

        // Save full UI data
        await _saveCachedWeather({
          'currentWeather': currentWeather,
          'hourlyForecast': hourlyForecast,
          'dailyForecast': dailyForecast,
        });
      } else {
        currentWeather = {};
      }
    } else {
      // Offline → load cached
      final cached = await _loadCachedWeather();
      if (cached != null) {
        currentWeather = cached['currentWeather'];
        hourlyForecast = cached['hourlyForecast'];
        dailyForecast = cached['dailyForecast'];
        isOffline = true;
      } else {
        currentWeather = {};
        isOffline = true;
      }
    }

    notifyListeners();
  }

  // --- Fetch weather by location
  Future<void> getWeatherDataWithLocation(
    Future<Position?> Function() getCurrentLocation,
  ) async {
    final hasConnection = await _hasInternetConnection();
    Position? position = await getCurrentLocation();

    if (position == null) {
      final cached = await _loadCachedWeather();
      if (cached != null) {
        currentWeather = cached['currentWeather'];
        hourlyForecast = cached['hourlyForecast'];
        dailyForecast = cached['dailyForecast'];
        isOffline = true;
      } else {
        currentWeather = {};
      }
      notifyListeners();
      return;
    }

    if (hasConnection) {
      final data = await _weatherService.fetchWeather(
        lat: position.latitude,
        lon: position.longitude,
      );

      if (data != null) {
        currentWeather = data;
        hourlyForecast = _generateHourlyForecast(data);
        dailyForecast = _getNextSevenDays();
        isOffline = false;

        // Save full UI data
        await _saveCachedWeather({
          'currentWeather': currentWeather,
          'hourlyForecast': hourlyForecast,
          'dailyForecast': dailyForecast,
        });
      } else {
        final cached = await _loadCachedWeather();
        if (cached != null) {
          currentWeather = cached['currentWeather'];
          hourlyForecast = cached['hourlyForecast'];
          dailyForecast = cached['dailyForecast'];
          isOffline = true;
        }
      }
    } else {
      final cached = await _loadCachedWeather();
      if (cached != null) {
        currentWeather = cached['currentWeather'];
        hourlyForecast = cached['hourlyForecast'];
        dailyForecast = cached['dailyForecast'];
        isOffline = true;
      } else {
        currentWeather = {};
      }
    }

    notifyListeners();
  }

  // --- Refresh
  Future<void> refreshData() async {
    isRefreshing = true;
    notifyListeners();

    if (currentWeather != null && currentWeather!['name'] != null) {
      await getWeatherData(city: currentWeather!['name']);
    }

    isRefreshing = false;
    notifyListeners();
  }

  // --- Generate dummy 6-hour forecast for demo
  List<Map<String, dynamic>> _generateHourlyForecast(
    Map<String, dynamic> data,
  ) {
    return List.generate(
      6,
      (index) => {
        'dt_txt': '2023-01-01 ${10 + index}:00:00',
        'main': {'temp': (data['main']['temp'] + index).round()},
        'weather': [
          {'icon': data['weather'][0]['icon']},
        ],
      },
    );
  }

  // --- Dummy 7-day forecast
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
