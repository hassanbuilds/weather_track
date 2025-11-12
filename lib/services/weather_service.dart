import 'package:http/http.dart' as http;
import 'dart:convert';
import '../scerets.dart';

class WeatherService {
  Future<Map<String, dynamic>?> fetchWeather({
    double? lat,
    double? lon,
    String? city,
  }) async {
    String urlString;

    if (city != null && city.isNotEmpty) {
      urlString =
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$openWeatherApiKey&units=metric';
    } else if (lat != null && lon != null) {
      urlString =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openWeatherApiKey&units=metric';
    } else {
      return null;
    }

    final url = Uri.parse(urlString);

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
