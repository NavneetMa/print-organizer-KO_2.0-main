import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kwantapo/utils/lib.dart';

class ShapesPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = AppTheme.colorPrimaryDark;
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}
