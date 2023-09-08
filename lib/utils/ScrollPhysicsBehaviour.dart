import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScrollPhysicsBehaviour extends ScrollBehavior {

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => const BouncingScrollPhysics();

}
