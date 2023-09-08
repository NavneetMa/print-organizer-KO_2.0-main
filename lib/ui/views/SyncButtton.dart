import 'package:flutter/material.dart';
import 'package:kwantapo/services/kitchen_sum_mode_api/KitchenSumModeAPI.dart';
import 'package:kwantapo/utils/AppConstants.dart';
import 'package:kwantapo/utils/AppTheme.dart';
class SyncButton extends StatefulWidget {
  const SyncButton({Key? key}) : super(key: key);

  @override
  State<SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () async {
            _controller.repeat();
            if(!AppConstants.clickOfClock){
              await KitchenSumModeAPI.getInstance.getAllKotData();
            }else{
              await KitchenSumModeAPI.getInstance.getSnoozedKotData();
            }
             _controller.stop();
          },
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'Sync',
                  style: TextStyle(
                    color: AppTheme.nearlyWhite,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
