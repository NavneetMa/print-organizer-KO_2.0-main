import 'package:flutter/material.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class SummationItem extends StatefulWidget{
  final AggregatedItem aggrItem;
  final int index;
  final void Function(bool, int) updateItemChecked;
  const SummationItem({
    Key? key,
    required this.index,
    required this.aggrItem,
    required this.updateItemChecked,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SummationItem();

}
class _SummationItem extends State<SummationItem> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text("${widget.aggrItem.count}x ${widget.aggrItem.item!.trim()} ${widget.aggrItem.unit!}", style: TextStyles().kotTextLarge()),),
        Checkbox(
          value: widget.aggrItem.checkbox,
          onChanged: onChanged,
          activeColor: AppTheme.greenCheck,
        )
      ],
    );
  }

  String getItemLine(Item e){
    if(e.item!.trim().startsWith("--")) {
      return e.item!.trim();
    } else {
      return "${e.quantity}x${e.unit!} ${e.item!.trim()}";
    }
  }

  void onChanged(bool? value) {
    setState(() {
      widget.aggrItem.checkbox = value!;
    });
    widget.updateItemChecked(value!, widget.index);
  }
}