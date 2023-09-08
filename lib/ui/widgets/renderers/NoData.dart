import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class NoData extends StatelessWidget {

  const NoData();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalization.instance.translate("no_kot_data"),
        style: TextStyles().titleStyleColored(),
      ),
    );
  }

}
