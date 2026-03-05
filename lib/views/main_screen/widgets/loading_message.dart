import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/weather_provider.dart';

class LoadingMessage extends StatelessWidget {
  final int messageIndex;
  const LoadingMessage({super.key, required this.messageIndex});

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<WeatherProvider>().messages;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Text(
        messages[messageIndex],
        key: ValueKey(messageIndex),
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    ).animate().fadeIn();
  }
}