import 'package:flutter/material.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/ui/lib.dart';

class LoadingDialog extends StatelessWidget {


  final String? message;

  const LoadingDialog({
    Key? key,

    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Container(
          height: 100,
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 50,
                  child: const LoadingIndicator(),
                ),
              ),
              Expanded(
                child: Text(
                  AppLocalization.instance.translate(message!),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

}