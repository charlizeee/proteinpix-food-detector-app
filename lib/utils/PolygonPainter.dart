import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter {
  final List<Map<String, double>> points;
  Color polygonColor;
  PolygonPainter({required this.points, required this.polygonColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = polygonColor.withOpacity(0.6)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0]['x']!, points[0]['y']!);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i]['x']!, points[i]['y']!);
      }
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}