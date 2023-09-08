import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwantapo/utils/AppSpaces.dart';

class BorderedContainer extends StatelessWidget {

  final Widget? child;

  const BorderedContainer({
    Key? key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSpaces().mediumVertical,
      padding: AppSpaces().smallAll,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(5.0),),
      ),
      child: child,
    );
  }

}