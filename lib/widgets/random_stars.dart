import 'dart:math';
import 'package:uniguru/widgets/point3d.dart';

List<Point3D> generateRandomStarPositions(
    int count, double width, double height) {
  final random = Random();
  final List<Point3D> positions = [];

  for (int i = 0; i < count; i++) {
    final x =
        random.nextDouble() * width; // Random x position within screen width
    final y =
        random.nextDouble() * height; // Random y position within screen height
    final z = random.nextDouble() *
        1000; // Random z (depth) position between 0 and 1000

    positions.add(Point3D(x, y, z)); // Store x, y, z in the Point3D class
  }
  return positions;
}
