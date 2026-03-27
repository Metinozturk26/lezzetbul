import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/app_constants.dart';

/// LezzetBul custom logo: A fork integrated into a location pin shape.
class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showBackground;
  final double backgroundRadius;

  const AppLogo({
    super.key,
    this.size = 64,
    this.color,
    this.showBackground = false,
    this.backgroundRadius = 30,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppConstants.primaryColor;

    final logo = CustomPaint(
      size: Size(size, size),
      painter: _ForkPinPainter(color: logoColor),
    );

    if (!showBackground) return logo;

    return Container(
      width: size * 1.8,
      height: size * 1.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(backgroundRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(child: logo),
    );
  }
}

class _ForkPinPainter extends CustomPainter {
  final Color color;

  _ForkPinPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // --- Location pin (outer shape) ---
    final pinPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw pin body: a rounded top with a pointed bottom
    final pinPath = Path();
    final pinCenterX = w * 0.5;
    final pinTopY = h * 0.02;
    final pinRadius = w * 0.42;
    final pinBottomY = h * 0.95;

    // Top circle of the pin
    pinPath.addArc(
      Rect.fromCircle(center: Offset(pinCenterX, pinTopY + pinRadius), radius: pinRadius),
      math.pi * 1.15,
      math.pi * 0.7,
    );

    // Right side curve down to point
    pinPath.quadraticBezierTo(
      w * 0.82, h * 0.55,
      pinCenterX, pinBottomY,
    );

    // Left side curve from point back up
    pinPath.quadraticBezierTo(
      w * 0.18, h * 0.55,
      w * 0.5 - pinRadius * math.sin(math.pi * 0.15),
      pinTopY + pinRadius - pinRadius * math.cos(math.pi * 0.15),
    );

    pinPath.close();
    canvas.drawPath(pinPath, pinPaint);

    // --- Inner circle (white cutout) ---
    final innerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final innerRadius = pinRadius * 0.62;
    final innerCenter = Offset(pinCenterX, pinTopY + pinRadius);
    canvas.drawCircle(innerCenter, innerRadius, innerCirclePaint);

    // --- Fork inside the circle ---
    final forkPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final forkCenterX = pinCenterX;
    final forkTop = innerCenter.dy - innerRadius * 0.7;
    final forkBottom = innerCenter.dy + innerRadius * 0.7;
    final forkMid = innerCenter.dy - innerRadius * 0.05;

    // Fork handle (center vertical line - bottom half)
    canvas.drawLine(
      Offset(forkCenterX, forkMid),
      Offset(forkCenterX, forkBottom),
      forkPaint,
    );

    // Fork prongs (3 vertical lines at top)
    final prongSpacing = innerRadius * 0.35;
    for (int i = -1; i <= 1; i++) {
      final px = forkCenterX + i * prongSpacing;
      canvas.drawLine(
        Offset(px, forkTop),
        Offset(px, forkMid),
        forkPaint,
      );
    }

    // Fork bridge (horizontal line connecting prongs)
    canvas.drawLine(
      Offset(forkCenterX - prongSpacing, forkMid),
      Offset(forkCenterX + prongSpacing, forkMid),
      forkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ForkPinPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
