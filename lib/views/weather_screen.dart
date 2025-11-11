// --- WEATHER SCREEN ---
// All imports remain the same
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_track/view_models/weather_view_model.dart';
import 'daily_forecast_item.dart';
import 'hourly_forecast_item.dart';
import 'dart:math';

// --- OFFLINE BANNER HEIGHT ---
const double offlineBannerHeight = 30;

// --- DYNAMIC GRADIENT FUNCTION ---
LinearGradient getWeatherGradient(String main, bool isDay) {
  switch (main) {
    case 'Clear':
      return isDay
          ? const LinearGradient(
            colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
          : const LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );
    case 'Clouds':
      return isDay
          ? const LinearGradient(
            colors: [Color(0xFF757F9A), Color(0xFFD7DDE8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
          : const LinearGradient(
            colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );
    case 'Rain':
      return const LinearGradient(
        colors: [Color(0xFF3a7bd5), Color(0xFF00d2ff)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    case 'Snow':
      return const LinearGradient(
        colors: [Color(0xFF83a4d4), Color(0xFFb6fbff)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    case 'Thunderstorm':
      return const LinearGradient(
        colors: [Color(0xFF141E30), Color(0xFF243B55)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    default:
      return const LinearGradient(
        colors: [Color(0xFF5B8CFF), Color(0xFF77B5FE)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
  }
}

// --- WEATHER EFFECTS WIDGET ---
class WeatherEffect extends StatelessWidget {
  final String mainWeather;
  final bool isDay;

  const WeatherEffect({
    super.key,
    required this.mainWeather,
    required this.isDay,
  });

  @override
  Widget build(BuildContext context) {
    switch (mainWeather) {
      case 'Clear':
        return isDay ? const SunEffect() : const StarsEffect();
      case 'Clouds':
        return const CloudEffect();
      case 'Rain':
        return const RainEffect();
      case 'Snow':
        return const SnowEffect();
      case 'Thunderstorm':
        return const ThunderEffect();
      default:
        return const SizedBox.shrink();
    }
  }
}

// --- EFFECTS IMPLEMENTATION ---
class SunEffect extends StatelessWidget {
  const SunEffect({super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Icon(
          WeatherIcons.day_sunny,
          color: Colors.yellow.withOpacity(0.6),
          size: 80,
        ),
      ),
    );
  }
}

class StarsEffect extends StatelessWidget {
  const StarsEffect({super.key});
  @override
  Widget build(BuildContext context) {
    final rand = Random();
    return Stack(
      children: List.generate(30, (index) {
        return Positioned(
          left: rand.nextDouble() * MediaQuery.of(context).size.width,
          top: rand.nextDouble() * MediaQuery.of(context).size.height / 2,
          child: Icon(
            Icons.star,
            color: Colors.white.withOpacity(rand.nextDouble()),
            size: rand.nextDouble() * 3 + 1,
          ),
        );
      }),
    );
  }
}

class CloudEffect extends StatelessWidget {
  const CloudEffect({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 50,
          left: 20,
          child: Icon(
            WeatherIcons.cloud,
            size: 120,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        Positioned(
          top: 100,
          right: 20,
          child: Icon(
            WeatherIcons.cloud,
            size: 100,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}

class RainEffect extends StatefulWidget {
  const RainEffect({super.key});
  @override
  State<RainEffect> createState() => _RainEffectState();
}

class _RainEffectState extends State<RainEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<RainDrop> _drops = [];
  final int dropCount = 200;
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < dropCount; i++) {
      _drops.add(RainDrop(_rand));
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(() {
      setState(() {
        _drops.forEach((d) => d.fall());
      });
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: RainPainter(_drops));
  }
}

class RainDrop {
  double x;
  double y;
  double length;
  double speed;
  final Random rand;

  RainDrop(this.rand)
    : x = rand.nextDouble(),
      y = rand.nextDouble(),
      length = rand.nextDouble() * 25 + 10,
      speed = rand.nextDouble() * 6 + 3;

  void fall() {
    y += speed / 100;
    if (y > 1) {
      y = 0;
      x = rand.nextDouble();
      length = rand.nextDouble() * 25 + 10;
      speed = rand.nextDouble() * 6 + 3;
    }
  }
}

class RainPainter extends CustomPainter {
  final List<RainDrop> drops;
  RainPainter(this.drops);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blueAccent.withOpacity(0.5)
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;

    for (var drop in drops) {
      final dx = drop.x * size.width;
      final dy = drop.y * size.height;
      canvas.drawLine(Offset(dx, dy), Offset(dx, dy + drop.length), paint);
    }

    final haze =
        Paint()
          ..color = Colors.white.withOpacity(0.06)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), haze);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SnowEffect extends StatelessWidget {
  const SnowEffect({super.key});
  @override
  Widget build(BuildContext context) {
    final rand = Random();
    return Stack(
      children: List.generate(50, (index) {
        return Positioned(
          left: rand.nextDouble() * MediaQuery.of(context).size.width,
          top: rand.nextDouble() * MediaQuery.of(context).size.height,
          child: Icon(
            Icons.ac_unit,
            size: rand.nextDouble() * 10 + 5,
            color: Colors.white.withOpacity(0.7),
          ),
        );
      }),
    );
  }
}

class ThunderEffect extends StatelessWidget {
  const ThunderEffect({super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Icon(
        WeatherIcons.lightning,
        size: 80,
        color: Colors.yellow.withOpacity(0.5),
      ),
    );
  }
}

// --- WEATHER SCREEN ---
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

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

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _changeCityDialog(WeatherViewModel vm) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Enter City Name"),
            content: TextField(
              controller: _cityController,
              decoration: const InputDecoration(hintText: "City name"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final cityName = _cityController.text.trim();
                  if (cityName.isNotEmpty) {
                    if (vm.isOffline) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "You are offline. Try again when connected to the internet.",
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    } else {
                      vm.getWeatherData(city: cityName);
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  bool _isDayFromSun(Map<String, dynamic>? weather) {
    if (weather == null) return true;
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final sunrise = weather['sys']?['sunrise'] ?? 0;
    final sunset = weather['sys']?['sunset'] ?? 1;
    return currentTime >= sunrise && currentTime <= sunset;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create:
          (_) =>
              WeatherViewModel()
                ..getWeatherDataWithLocation(_getCurrentLocation),
      child: Consumer<WeatherViewModel>(
        builder: (context, vm, child) {
          if (vm.currentWeather == null || vm.currentWeather!.isEmpty) {
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
          final windSpeed = vm.currentWeather?['wind']?['speed'] ?? '--';
          final cityName = vm.currentWeather?['name'] ?? 'Location';

          final mainWeather = vm.currentWeather?['weather']?[0]?['main'] ?? '';
          final iconCode = vm.currentWeather?['weather']?[0]?['icon'] ?? '01d';

          final isDay = _isDayFromSun(vm.currentWeather);

          final primaryColor = isDay ? Colors.white : Colors.white70;
          final secondaryColor = isDay ? Colors.white70 : Colors.grey[400]!;

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(''),
              backgroundColor:
                  getWeatherGradient(mainWeather, isDay).colors.first,
              elevation: 0,
              actions: [
                IconButton(
                  icon:
                      vm.isRefreshing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(Icons.refresh, color: Colors.white),
                  onPressed: vm.isRefreshing ? null : vm.refreshData,
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => _changeCityDialog(vm),
                ),
              ],
            ),
            body: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: getWeatherGradient(mainWeather, isDay),
                  ),
                ),
                WeatherEffect(mainWeather: mainWeather, isDay: isDay),

                //  OFFLINE BANNER (sticky)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  top: 0,
                  left: 0,
                  right: 0,
                  height: vm.isOffline ? offlineBannerHeight : 0,
                  child: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.center,
                    child: const Text(
                      "You are offline",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: vm.isOffline ? offlineBannerHeight : 0,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // --- TOP WEATHER HEADER ---
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.025,
                              vertical: screenHeight * 0.015,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'My Location',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.008),
                                    Text(
                                      cityName,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.07,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.012),
                                    Text(
                                      description.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.008),
                                    Text(
                                      'H:${highTemp ?? '--'}°  L:${lowTemp ?? '--'}°',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 700),
                                  child: Icon(
                                    mapWeatherIcon(iconCode),
                                    key: ValueKey(iconCode),
                                    size: screenWidth * 0.22,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Center(
                            child: Text(
                              '${temp ?? '--'}°',
                              style: TextStyle(
                                fontSize: screenWidth * 0.22,
                                fontWeight: FontWeight.w200,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // Hourly forecast
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.03,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                              horizontal: screenWidth * 0.03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: screenWidth * 0.025,
                                    bottom: screenHeight * 0.015,
                                  ),
                                  child: Text(
                                    "$description. Wind gusts are up to $windSpeed m/s.",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: screenWidth * 0.025,
                                    bottom: screenHeight * 0.01,
                                  ),
                                  child: Text(
                                    'HOURLY FORECAST',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.12,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: vm.hourlyForecast.length,
                                    itemBuilder: (context, index) {
                                      final forecast = vm.hourlyForecast[index];
                                      final time = forecast['dt_txt']
                                          .toString()
                                          .split(' ')[1]
                                          .substring(0, 5);
                                      final hour = int.parse(
                                        time.split(':')[0],
                                      );
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

                                      final temp =
                                          forecast['main']['temp'].round();
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
                          SizedBox(height: screenHeight * 0.02),
                          // 7-Day Forecast
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.03,
                              ),
                            ),
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '7-DAY FORECAST',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.015),
                                Column(
                                  children:
                                      vm.dailyForecast
                                          .map(
                                            (dayData) => DailyForecastItem(
                                              day: dayData['day'],
                                              lowTemp: dayData['low'],
                                              highTemp: dayData['high'],
                                              icon: mapWeatherIcon(
                                                dayData['icon'],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
