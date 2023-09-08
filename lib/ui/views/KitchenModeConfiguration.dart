import 'package:flutter/material.dart';
import 'package:kwantapo/ui/activities/model/ConfigurationActivityModel.dart';
import 'package:kwantapo/ui/views/IPAddressContainer.dart';

class KitchenModeConfiguration extends StatefulWidget {
  final String? Function(ValidEnum,String?) validate;
  final void Function(String,ValidEnum) onSaved;
  final Future<void> Function() saveKitchenModeForm;
  final void Function() clearKitchenModeInputs;
  final GlobalKey<FormState> kitchenModeForm;
  final TextEditingController? kModeIpAddress;
  final TextEditingController? kModePortNum;

  const KitchenModeConfiguration({
    Key? key,
    required this.validate,
    required this.onSaved,
    required this.kModeIpAddress,
    required this.kModePortNum,
    required this.saveKitchenModeForm,
    required this.kitchenModeForm,
    required this.clearKitchenModeInputs,
  }) : super(key: key);

  @override
  State<KitchenModeConfiguration> createState() => _KitchenModeConfigurationState();
}

class _KitchenModeConfigurationState extends State<KitchenModeConfiguration> {
  @override
  Widget build(BuildContext context) {
    return IPAddressContainer(
      validate: widget.validate,
      portNum: widget.kModePortNum,
      ipAddress: widget.kModeIpAddress,
      clearModeInputs: widget.clearKitchenModeInputs,
      modeForm: widget.kitchenModeForm,
      onSaved: widget.onSaved,
      saveModeForm: widget.saveKitchenModeForm,
      text: "Kitchen Mode",
    );
  }
}
