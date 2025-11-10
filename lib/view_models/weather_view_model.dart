import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  bool isRefreshing = false;
  Map<String, dynamic>? currentWeather;
  List<dynamic> hourlyForecast = [];
  List<dynamic> dailyForecast = [];

  final WeatherService _weatherService = WeatherService();

  Future<void> getWeatherData() async {
    final data = await _weatherService.fetchWeather();
    if (data != null) {
      currentWeather = data;

      // Dummy hourly forecast
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
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    isRefreshing = true;
    notifyListeners();
    await getWeatherData();
    isRefreshing = false;
    notifyListeners();
  }

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
