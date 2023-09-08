import 'package:flutter/material.dart';
import 'package:kwantapo/ui/activities/model/ConfigurationActivityModel.dart';
import 'package:kwantapo/ui/views/IPAddressContainer.dart';



class MasterTerminalConfiguration extends StatefulWidget {
  final String? Function(ValidEnum,String?) validate;
  final void Function(String,ValidEnum) onSaved;
  final Future<void> Function() saveMasterForm;
  final void Function() clearMasterInputs;
  final GlobalKey<FormState> masterForm;
  final TextEditingController? masterTerminalIpAddress;
  final TextEditingController? masterTerminalPortNum;

  const MasterTerminalConfiguration({
    Key? key,
    required this.validate,
    required this.onSaved,
    required this.masterTerminalIpAddress,
    required this.masterTerminalPortNum,
    required this.saveMasterForm,
    required this.masterForm,
    required this.clearMasterInputs,
  }) : super(key: key);

  @override
  State<MasterTerminalConfiguration> createState() => _MasterTerminalConfigurationState();
}

class _MasterTerminalConfigurationState extends State<MasterTerminalConfiguration> {
  @override
  Widget build(BuildContext context) {
    return IPAddressContainer(
      text: "master_terminal_configuration",
      saveModeForm: widget.saveMasterForm,
      onSaved: widget.onSaved,
      modeForm: widget.masterForm,
      clearModeInputs: widget.clearMasterInputs,
      ipAddress: widget.masterTerminalIpAddress,
      portNum: widget.masterTerminalPortNum,
      validate: widget.validate,
    );
  }
}

