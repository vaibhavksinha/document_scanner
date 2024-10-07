import 'package:flutter/material.dart';

// Reusable animated FloatingActionButton widget
class FloatingActionButtonWithAnimation extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String heroTag;

  const FloatingActionButtonWithAnimation({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 200),
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}