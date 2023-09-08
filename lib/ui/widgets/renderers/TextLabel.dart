import 'package:flutter/cupertino.dart';
import 'package:kwantapo/utils/lib.dart';

class TextLabel extends StatelessWidget {

  final String? title;

  const TextLabel({
    Key? key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Text(
          title!,
          textWidthBasis: TextWidthBasis.parent,
          style: TextStyles().inputValueStyle(),
      ),
    );
  }

}
