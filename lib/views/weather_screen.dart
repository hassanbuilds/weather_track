import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_track/view_models/weather_view_model.dart';
import 'hourly_forecast_item.dart';
import 'daily_forecast_item.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
    return ChangeNotifierProvider(
      create: (_) => WeatherViewModel()..getWeatherData(),
      child: Consumer<WeatherViewModel>(
        builder: (context, vm, child) {
          if (vm.currentWeather == null) {
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

          final temp = vm.currentWeather?['main']?['temp']?.round();
          final description =
              vm.currentWeather?['weather']?[0]?['description'] ?? '';
          final highTemp = vm.currentWeather?['main']?['temp_max']?.round();
          final lowTemp = vm.currentWeather?['main']?['temp_min']?.round();

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(''),
              backgroundColor: const Color(0xFF5B8CFF),
              elevation: 0,
              actions: [
                IconButton(
                  icon:
                      vm.isRefreshing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(Icons.refresh, color: Colors.white),
                  onPressed: vm.isRefreshing ? null : vm.refreshData,
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
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'My Location',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Lahore, Pakistan',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

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

                      Center(
                        child: Text(
                          description.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Center(
                        child: Text(
                          'H:${highTemp ?? '--'}° L:${lowTemp ?? '--'}°',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Hourly forecast section
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
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
                                itemCount: vm.hourlyForecast.length,
                                itemBuilder: (context, index) {
                                  final forecast = vm.hourlyForecast[index];
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

                      // 7-Day Forecast section
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
                                  vm.dailyForecast.map((dayData) {
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
        },
      ),
    );
  }
}
