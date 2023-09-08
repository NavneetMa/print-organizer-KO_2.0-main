import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwantapo/ui/activities/model/ConfigurationActivityModel.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class FormTextInput extends StatefulWidget {
  final BuildContext? context;
  final TextEditingController? controller;
  final String? title;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validate;
  final Function(String?)? onSaved;
  final ValidEnum? enumerate;
  final String? hintText;
  const FormTextInput({
    @required this.context,
    @required this.title,
    @required this.controller,
    @required this.enumerate,
    @required this.onSaved,
    @required this.validate,
    this.hintText,
    this.maxLength,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
  });

  @override
  _FormEmailInputState createState() => _FormEmailInputState();
}

class _FormEmailInputState extends State<FormTextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
            controller: widget.controller,
            style: TextStyles().textInputStyle(),
            textAlign: TextAlign.left,
            cursorColor: AppTheme.grey,
            maxLength: widget.maxLength,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.enumerate == ValidEnum.IPADDRESS
                ? [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                  ]
                : widget.enumerate == ValidEnum.PORT
                    ? [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                      ]
                    : [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9-]')),
                      ],
              textInputAction: widget.textInputAction,
              decoration: InputDecoration(
                hintText: widget.hintText,
              contentPadding: AppSpaces().smallVerticalHorizontal,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:  const BorderSide(color:  AppTheme.colorPrimaryDark),
              ),
              labelText: widget.title,
              labelStyle: TextStyles().textInputStyleLight(),
              ),
              validator: widget.validate,
              onSaved: widget.onSaved,);
  }
}
