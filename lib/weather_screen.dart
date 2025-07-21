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
      body: Column(
        children: [
          // main card
          const Placeholder(fallbackHeight: 250),
          const SizedBox(height: 25),
          // Weather forecast cards
          const Placeholder(fallbackHeight: 150),
          const SizedBox(height: 20),
          const Placeholder(fallbackHeight: 150),
        ],
      ),
    );
  }
}
