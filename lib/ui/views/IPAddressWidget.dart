import 'package:flutter/material.dart';
import 'package:kwantapo/lang/AppLocalization.dart';
import 'package:kwantapo/sync/objects/Config.dart';
import 'package:kwantapo/ui/widgets/renderers/BorderedContainer.dart';

class IPAddressWidget extends StatefulWidget {
  final String wifiIP;
  final Future<void> Function() refresh;
  const IPAddressWidget({
    required this.wifiIP,
    required this.refresh,
  });
  @override
  _IPAddressWidgetState createState() => _IPAddressWidgetState();
}

class _IPAddressWidgetState extends State<IPAddressWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BorderedContainer(
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${AppLocalization.instance.translate("your_ip_address")} ${widget.wifiIP}:${Config.socketPort}",
            ),
          ),
          IconButton(
            onPressed: () async {
              _animationController.forward(from: 0.0);
              widget.refresh();
            },
            icon: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
