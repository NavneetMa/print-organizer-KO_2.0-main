import 'package:flutter/cupertino.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class FormSwitchInput extends StatefulWidget {

  final BuildContext? context;
  final String? title;
  final bool? value;
  final Function(bool)? onChanged;

  const FormSwitchInput({
    Key? key,
    @required this.context,
    @required this.title,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _FormSwitchInputState createState() => _FormSwitchInputState();

}

class _FormSwitchInputState extends State<FormSwitchInput> {

  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    _isSwitched = widget.value!;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextLabel(title: widget.title),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalization.instance.translate("no"),
                style: TextStyles().hintStyle(),
              ),
              CupertinoSwitch(
                value: _isSwitched,
                onChanged: (bool? value) => _onChanged(value!),
                activeColor: AppTheme.colorAccent,
              ),
              Text(
                AppLocalization.instance.translate("yes"),
                style: TextStyles().hintStyle(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onChanged(bool value) {
    widget.onChanged!(value);
    setState(() => _isSwitched = value);
  }

}
