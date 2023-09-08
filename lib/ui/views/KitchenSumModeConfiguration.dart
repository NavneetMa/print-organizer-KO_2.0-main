import 'package:flutter/material.dart';
import 'package:kwantapo/ui/activities/model/ConfigurationActivityModel.dart';
import 'package:kwantapo/ui/views/IPAddressContainer.dart';

class KitchenSumModeConfiguration extends StatefulWidget {
  final String? Function(ValidEnum,String?) validate;
  final void Function(String,ValidEnum) onSaved;
  final Future<void> Function() saveKitchenSumModeForm;
  final void Function() clearKitchenSumModeInputs;
  final GlobalKey<FormState> kitchenSumModeForm;
  final TextEditingController? kSumModeIpAddress;
  final TextEditingController? kSumModePortNum;

  const KitchenSumModeConfiguration({
    Key? key,
    required this.validate,
    required this.onSaved,
    required this.kSumModeIpAddress,
    required this.kSumModePortNum,
    required this.saveKitchenSumModeForm,
    required this.kitchenSumModeForm,
    required this.clearKitchenSumModeInputs,
  }) : super(key: key);

  @override
  State<KitchenSumModeConfiguration> createState() => _KitchenSumModeConfigurationState();
}

class _KitchenSumModeConfigurationState extends State<KitchenSumModeConfiguration> {
  @override
  Widget build(BuildContext context) {
    return IPAddressContainer(
      validate: widget.validate,
      portNum: widget.kSumModePortNum,
      ipAddress: widget.kSumModeIpAddress,
      clearModeInputs: widget.clearKitchenSumModeInputs,
      modeForm: widget.kitchenSumModeForm,
      onSaved: widget.onSaved,
      saveModeForm: widget.saveKitchenSumModeForm,
      text: "Kitchen Sum Mode",
    );
  }
}
