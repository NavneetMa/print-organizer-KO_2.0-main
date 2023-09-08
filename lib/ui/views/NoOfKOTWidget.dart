import 'package:flutter/material.dart';
import 'package:kwantapo/lang/AppLocalization.dart';
import 'package:kwantapo/services/SystemService.dart';
import 'package:kwantapo/ui/widgets/renderers/BorderedContainer.dart';
import 'package:kwantapo/utils/AppConstants.dart';
import 'package:kwantapo/utils/AppTheme.dart';

class NoOfKOTWidget extends StatefulWidget {
  final int noOfKOT;
  final Function(int) onNoOfKOTChanged;
  const NoOfKOTWidget({
    required this.noOfKOT,
    required this.onNoOfKOTChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<NoOfKOTWidget> createState() => _NoOfKOTWidgetState();
}

class _NoOfKOTWidgetState extends State<NoOfKOTWidget> {
  final List<Map<int, String>> _noOfPrint = [{1: "1"}, {2: "2"}, {3: "3"}, {4: "4"},{5: "5"},{6: "6"},{8: "8"},{10: "10"},{12: "12"}];
  @override
  Widget build(BuildContext context) {
    return BorderedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalization.instance.translate("no_of_kot")),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _noOfPrint.map((data) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<int>(
                    value: data.keys.first,
                    groupValue: widget.noOfKOT,
                    activeColor: AppTheme.colorAccent,
                    onChanged: (int? value) {
                      AppConstants.noOfKot = value!;
                      SystemService.getInstance.updateNoOfKOT(context, value);
                      widget.onNoOfKOTChanged(value);
                    },
                  ),
                  Text(data.values.first),
                  const SizedBox(width: 20,)
                ],
              ),).toList(),
            ),
          )
        ],
      ),
    );
  }
}
