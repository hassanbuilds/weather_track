import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  const AdditionalInfoItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.water_drop, size: 32),
        SizedBox(height: 8),
        Text('Humidity'),
        SizedBox(height: 8),
        Text('91', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
