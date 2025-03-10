import 'dart:math';
import 'package:flutter/material.dart';
import 'point3d.dart';

class StarPainter extends CustomPainter {
  final List<Point3D> starPositions;
  final double elapsedTime;
  final double width;
  final double height;

  StarPainter(this.starPositions, this.elapsedTime, this.width, this.height);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final center = Offset(size.width / 2, size.height / 2);

    for (final star in starPositions) {
      // Move stars closer to the viewer over time (warp-speed effect)
      star.z -= 2; // Adjust speed as needed

      // Reset star position if it moves out of view
      if (star.z <= 0) {
        star.z = 1000;
        star.x = (Random().nextDouble() * 2 - 1) * width;
        star.y = (Random().nextDouble() * 2 - 1) * height;
      }

      // Apply horizontal rotation (rotation around the Y-axis, for horizontal rotation effect)
      final angle =
          elapsedTime * 0.2; // Rotation speed around the Y-axis (horizontal)
      final cosAngle = cos(angle);
      final sinAngle = sin(angle);

      final rotatedX = star.x * cosAngle - star.z * sinAngle;
      final rotatedZ = star.x * sinAngle + star.z * cosAngle;

      // Apply perspective projection based on z depth
      final scale = 500 / rotatedZ; // Simple perspective projection
      final adjustedX = rotatedX * scale + center.dx;
      final adjustedY = star.y * scale +
          center.dy; // Maintain the Y-coordinate without rotation

      // Adjust size based on z position (stars appear larger as they get closer)
      final radius = max(0.5, 1 * scale);

      // Draw the star
      canvas.drawCircle(Offset(adjustedX, adjustedY), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>true;
}