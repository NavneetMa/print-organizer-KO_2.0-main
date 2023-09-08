import 'package:flutter/material.dart';
import 'package:kwantapo/data/podos/lib.dart';
import 'package:kwantapo/utils/lib.dart';

class CardItems extends StatefulWidget {
  final Item item;
  final int singleCategory;
  final void Function(bool, Item, int) updateItemChecked;
  final int itemIndex;

  const CardItems({
    Key? key,
    required this.item,
    required this.updateItemChecked,
    required this.itemIndex,
    required this.singleCategory,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardItems();
}

class _CardItems extends State<CardItems> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: getItemLine(widget.item)),
        if (AppConstants.printCategorySlip && widget.singleCategory == 0) Expanded(
          child: Checkbox(
            value: widget.item.checkbox,
            onChanged: onChanged,
            activeColor: AppTheme.greenCheck,
          ),
        ) else Container()
      ],
    );
  }

  Text getItemLine(Item e) {
    var itemDisplay = "";
    bool isCategory= false;
    var item = "";
    if (e.item!.trim().startsWith("--")) {
      isCategory = true;
      item = e.item!;
    } else {
      item = e.quantity.toString()+"x"+e.unit!+" "+e.item!.trim();
    }
    if(AppConstants.printCategorySlip && item.length>20){
      itemDisplay = item.trim().substring(0,20);
    } else {
      if(item.length>20) {
        itemDisplay = item.trim().substring(0, 23);
      }
     itemDisplay = item.trim();
    }
    if(isCategory){
      return Text(itemDisplay, style: TextStyles().kotTextLargeCategory());
    }else{
      return Text(itemDisplay, style: TextStyles().kotTextLarge());
    }

  }

  void onChanged(bool? value) {
    setState(() {
      widget.item.checkbox = value!;
    });
    widget.updateItemChecked(value!, widget.item, widget.itemIndex,);
  }
}
