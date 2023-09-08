import 'package:flutter/material.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class DismissibleCard extends StatefulWidget {
  final void Function(BuildContext) swipeUpToRemoveKotSummation;
  const DismissibleCard({
    Key? key,
     required this.swipeUpToRemoveKotSummation,
  }) : super(key: key);

  @override
  State<DismissibleCard> createState() => _DismissibleCardState();
}

class _DismissibleCardState extends State<DismissibleCard> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.up,
        onDismissed: (DismissDirection direction) => widget.swipeUpToRemoveKotSummation(context),
        child: Card(
          child: Stack(
            children: [
              Container(
                margin: AppSpaces().mediumLeftBottomTop,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(AppLocalization.instance.translate("total"), style: TextStyles().titleStyleLargeBlack()),
                        SizedBox(
                            width: 32,
                            height: 32,
                            child: IconButton(
                              icon: Image.asset(Assets.summation),
                              onPressed: () => {},
                            ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        alignment:Alignment.topLeft,
                        child: const AggregatedItemFullViewWidget(),
                      ),
                    ),
                  ],
                ),
              ),
              TriangleSwipe(),
            ],
          ),
        ),
    );
  }
}
