import 'package:flutter/material.dart';
import 'package:kwantapo/utils/AppTheme.dart';

class NumberButton extends StatelessWidget{

  final int number;
  final void Function(int) setMinutes;
  const NumberButton(this.number, this.setMinutes);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppTheme.greyBack),
            side: MaterialStateProperty.all(const BorderSide(color: AppTheme.colorPrimary, width: 2)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(color: Colors.red),
                ),
            ),
            fixedSize: MaterialStateProperty.all(const Size(40, 40)),
          ),
          onPressed: () => setMinutes(number),
          child:
          Text(number.toString()),
      ),
    );
  }

}