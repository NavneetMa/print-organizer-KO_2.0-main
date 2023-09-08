import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:kwantapo/utils/lib.dart';

class ByteToImagePaint extends CustomPainter {

  final String _tag = "ByteToImagePaint";
  List<int> imageInt = [];
  final List<int> _doubleWidth = [];
  int width = 0;
  int height = 0;

  ByteToImagePaint(this.imageInt);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = AppTheme.nearlyBlack;
    getRectPoint(canvas, paint);
  }

  void getRectPoint(Canvas canvas, Paint paint) {
    try {
      width = imageInt[0];
      height = imageInt[2];
      double column = 0, row = 0;
      for (int i = 4; i < imageInt.length; i++) {
        for (int k = 0; k < 8; k++) {
          _doubleWidth.add(imageInt[i]);
        }
      }
      column = 0;
      for (int i = 0; i < _doubleWidth.length; i = i + width * 8) {
        row = 0;
        for (int j = i; j < i + width * 8; j++) {
          if (_doubleWidth[j] != 0) {
            canvas.drawOval(Rect.fromLTWH(row, column, 1, 1), paint);
          }
          row++;
        }
        column++;
      }
    } catch (error) {
      Logger.getInstance.d(_tag, "getRectPoint()", message: error.toString());
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  Future<ByteData?> getImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(Offset.zero, const Offset(200.0, 200.0)));

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = AppTheme.nearlyBlack;
    double column = 0;
    for (int i = 0; i < _doubleWidth.length; i = i + width * 8) {
      double row = 0;
      for (int j = i; j < i + width * 8; j++) {
        if (_doubleWidth[j] != 0) {
          canvas.drawOval(Rect.fromLTWH(row, column, 1, 1), paint);
        }
        row++;
      }
      column++;
    }

    final picture = recorder.endRecording();
    final img = picture.toImage(200, 200);
    final pngBytes = await img.then((value) => value.toByteData(format: ui.ImageByteFormat.png));
    return pngBytes;
  }

}
