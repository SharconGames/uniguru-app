import 'dart:math';
import 'package:uniguru/widgets/starScreen/point3d.dart';

List<Point3D> generateRandomStarPositions(
    int count, double width, double height) {
  final random = Random();
  final List<Point3D> positions = [];

  for (int i = 0; i < count; i++) {
    final x = (random.nextDouble() * 2 - 1) * width; // Random x position
    final y = (random.nextDouble() * 2 - 1) * height; // Random y position
    final z = random.nextDouble() * 1000 + 500; // Random depth (z > 0)

    positions.add(Point3D(x, y, z));
  }
  return positions;
}