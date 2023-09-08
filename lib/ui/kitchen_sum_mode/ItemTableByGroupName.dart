import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kwantapo/data/podos/AggregatedItem.dart';
import 'package:kwantapo/utils/TextStyles.dart';

class ItemTableByGroupName extends StatefulWidget {
  final HashMap<String, List<AggregatedItem>> data;

  const ItemTableByGroupName({required this.data});

  @override
  State<ItemTableByGroupName> createState() => _ItemTableByGroupNameState();
}

class _ItemTableByGroupNameState extends State<ItemTableByGroupName> {
  @override
  Widget build(BuildContext context) {
    List<String> headers = widget.data.keys.toList();

    return Container(
      padding: const EdgeInsets.only(top: 16.0,left: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(width: 2.0, color: Colors.black),
            columnWidths: _getColumnWidths(headers),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                children: headers.map((header) {
                  return TableCell(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(header,style: TextStyles().kotTextLargeSummation(),),
                    ),
                  );
                }).toList(),
              ),
              ..._buildRows(widget.data),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildRows(Map<String, List<AggregatedItem>> data) {
    List<TableRow> rows = [];

    int maxLength = 0;
    data.values.forEach((list) {
      if (list.length > maxLength) {
        maxLength = list.length;
      }
    });

    for (int i = 0; i < maxLength; i++) {
      List<Widget> cells = [];

      data.forEach((groupName, items) {
        if (i < items.length) {
          cells.add(
            TableCell(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Text('${items[i].count}x ${items[i].item!} ${items[i].unit}',style: TextStyles().kotTextLargeSummation()),
              ),
            ),
          );
        } else {
          cells.add(
            TableCell(
              child: Container(),
            ),
          );
        }
      });

      rows.add(
        TableRow(
          children: cells,
        ),
      );
    }

    return rows;
  }

  Map<int, TableColumnWidth> _getColumnWidths(List<String> headers) {
    final Map<int, TableColumnWidth> columnWidths = {};
    for (int i = 0; i < headers.length; i++) {
      columnWidths[i] = IntrinsicColumnWidth();
    }
    return columnWidths;
  }
}
