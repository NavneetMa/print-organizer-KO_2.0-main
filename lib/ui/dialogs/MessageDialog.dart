import 'package:flutter/material.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class MessageDialog extends StatelessWidget {

  final String? message;
  final String? title;

  const MessageDialog({
    this.message,
    this.title
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _getTitle(title),
      content: Text(AppLocalization.instance.translate(message!)),
      actions: [
        TextButton(
          onPressed: () => NavigationService.getInstance.goBack(),
          child: Text(
            AppLocalization.instance.translate("ok"),
            style: TextStyles().dialogButtonStyle(),
          ),
        ),
      ],
    );
  }

  Text _getTitle(String? title){
    if(title==null || title.isEmpty){
      return Text(AppLocalization.instance.translate("alert"));
    }else {
      return Text(title);
    }
  }

}
