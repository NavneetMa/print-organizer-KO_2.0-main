import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class TriangleSwipe extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: CustomPaint(
        painter: ShapesPainter(),
        child: SizedBox(
          height: 65,
          width: 65,
          child: Center(
            child: Padding(
              padding: AppSpaces().mediumLeftBottom,
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Text(
                  AppLocalization.instance.translate("swipe"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles().titleStyleMedium(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}