import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/ui/lib.dart';

class FormSwitch extends StatelessWidget {

  final bool? value;
  final String? title;
  final void Function(bool) onChanged;

  const FormSwitch({
    Key? key,
    @required this.value,
    @required this.title,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderedContainer(
      child: FormSwitchInput(
        context: context,
        title: AppLocalization.instance.translate(title!),
        value: value,
        onChanged: (bool? value) => onChanged(value!),
      ),
    );
  }
}
