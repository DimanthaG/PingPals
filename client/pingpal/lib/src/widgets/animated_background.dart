import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final int _particleCount = 30;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize particles
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
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
        ),

        // Animated particles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(_particles, _controller.value),
              size: Size.infinite,
            );
          },
        ),

        // Main content
        widget.child,
      ],
    );
  }
}

// Particle class to represent each floating particle
class Particle {
  late double x;
  late double y;
  late double size;
  late double speedX;
  late double speedY;
  late Color color;
  late double opacity;

  Particle() {
    reset();
  }

  void reset() {
    final random = math.Random();
    x = random.nextDouble();
    y = random.nextDouble();
    size = 0.8 + random.nextDouble() * 2.0; // Bigger particles

    // Random direction with slow movement
    speedX = (random.nextDouble() - 0.5) * 0.0005;
    speedY = (random.nextDouble() - 0.5) * 0.0005;

    // Orange-themed particles
    final colorValue = random.nextDouble();
    if (colorValue < 0.6) {
      // Orange shades
      color = Color.lerp(
        const Color(0xFFFF8C00),
        const Color(0xFFFFA500),
        random.nextDouble(),
      )!;
    } else if (colorValue < 0.9) {
      // White/yellow for contrast
      color = Color.lerp(
        Colors.white,
        const Color(0xFFFFD700),
        random.nextDouble(),
      )!;
    } else {
      // Occasional red
      color = const Color(0xFFFF4500);
    }

    opacity = 0.1 + random.nextDouble() * 0.2; // Lower opacity
  }

  void update(double delta) {
    x += speedX * delta;
    y += speedY * delta;

    if (x < 0) x = 1.0;
    if (x > 1.0) x = 0.0;
    if (y < 0) y = 1.0;
    if (y > 1.0) y = 0.0;

    if (math.Random().nextDouble() < 0.01) {
      speedX += (math.Random().nextDouble() - 0.5) * 0.0001;
      speedY += (math.Random().nextDouble() - 0.5) * 0.0001;
      speedX = speedX.clamp(-0.0008, 0.0008);
      speedY = speedY.clamp(-0.0008, 0.0008);
    }
  }
}

// CustomPainter to draw the particles
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update(10.0);

      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );

      if (particle.size > 0.8) {
        canvas.drawCircle(
          Offset(particle.x * size.width, particle.y * size.height),
          particle.size * 1.5,
          Paint()
            ..color = particle.color.withOpacity(particle.opacity * 0.2)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
        );
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
