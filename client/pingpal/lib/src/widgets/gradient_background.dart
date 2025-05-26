import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1A1A1A),
            Color.fromARGB(255, 185, 58, 3),
            Color(0xFF1A1A1A),
          ],
          stops: [0.1, 0.6, 0.9],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
    );
  }
}
