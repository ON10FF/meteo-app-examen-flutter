import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AnimatedGauge extends StatelessWidget {
  final double progress;
  const AnimatedGauge({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 15.0,
        animation: true,
        animateFromLastPercent: true,
        percent: progress.clamp(0.0, 1.0),
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.cloud_download, size: 30),
          ],
        ),
        progressColor: Colors.blue,
        backgroundColor: Colors.blue.shade100,
        circularStrokeCap: CircularStrokeCap.round,
      ),
    );
  }
}