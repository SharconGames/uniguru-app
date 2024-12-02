import 'dart:math';
import 'package:flutter/material.dart';
import 'point3d.dart'; // Import the Point3D class

class StarPainter extends CustomPainter {
  final List<Point3D> starPositions;
  final List<double> rotationSpeeds; // Unique rotation speeds for each star
  final double elapsedTime; // Time since animation started

  StarPainter(this.starPositions, this.rotationSpeeds, this.elapsedTime);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final center =
        Offset(size.width / 2, size.height / 2); // Center of the screen

    for (int i = 0; i < starPositions.length; i++) {
      final star = starPositions[i];

      // Apply 3D rotation to each star (rotate around X, Y, and Z axes)
      final angleX = elapsedTime * rotationSpeeds[i];
      final angleY = elapsedTime * rotationSpeeds[i] * 0.5;
      //final angleZ = elapsedTime * rotationSpeeds[i] * 0.5;

      // Rotate around the X and Y axes
      final cosX = cos(angleX);
      final sinX = sin(angleX);
      final cosY = cos(angleY);
      final sinY = sin(angleY);

      final newX = cosY * star.x - sinY * cosX * star.y + sinY * sinX * star.z;
      final newY = sinX * star.y + cosX * star.z;
      final newZ = cosX * cosY * star.z + sinX * star.y + sinY * star.x;

      // Perspective projection based on z position
      double scale = 1 / (1 + newZ / 500); // Simple perspective effect
      final adjustedX = (newX * scale) + size.width / 2;
      final adjustedY = (newY * scale) + size.height / 2;

      // Adjust size based on z position (stars get larger as they approach)
      final radius = 1 * scale; // Adjust multiplier for better scaling

      // Draw the star
      canvas.drawCircle(Offset(adjustedX, adjustedY), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
