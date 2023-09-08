import 'package:flutter/material.dart';
import 'package:kwantapo/utils/lib.dart';

class Snack {
  void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyles().inputValueStyleWhite(),
          ),
        ),
    );
  }

}