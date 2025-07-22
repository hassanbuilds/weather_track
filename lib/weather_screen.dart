import 'dart:ui';
import 'package:flutter/material.dart';

class WeatherScreeen extends StatelessWidget {
  const WeatherScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 14,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: const [
                          Text(
                            '300°F',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Icon(Icons.cloud, size: 64),
                          SizedBox(height: 16),
                          Text('Rain', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Card(
                        elevation: 6,
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '03:00',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Icon(Icons.cloud, size: 32),
                              const SizedBox(height: 8),
                              Text('320.21'),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 6,
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '03:00',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Icon(Icons.cloud, size: 32),
                              const SizedBox(height: 8),
                              Text('320.21'),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 6,
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '03:00',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Icon(Icons.cloud, size: 32),
                              const SizedBox(height: 8),
                              Text('320.21'),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 6,
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '03:00',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Icon(Icons.cloud, size: 32),
                              const SizedBox(height: 8),
                              Text('320.21'),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 6,
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '03:00',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Icon(Icons.cloud, size: 32),
                              const SizedBox(height: 8),
                              Text('320.21'),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 6,
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '03:00',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Icon(Icons.cloud, size: 32),
                              const SizedBox(height: 8),
                              Text('320.21'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Placeholder(fallbackHeight: 150),
                SizedBox(height: 20),
                Placeholder(fallbackHeight: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
