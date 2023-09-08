import 'package:flutter/material.dart';
import 'package:kwantapo/lang/AppLocalization.dart';
import 'package:kwantapo/ui/activities/model/ConfigurationActivityModel.dart';
import 'package:kwantapo/ui/widgets/inputs/FormTextInput.dart';
import 'package:kwantapo/ui/widgets/renderers/BorderedContainer.dart';
import 'package:kwantapo/utils/AppSpaces.dart';

class IPAddressContainer extends StatefulWidget {
  final String text;
  final String? Function(ValidEnum,String?) validate;
  final void Function(String,ValidEnum) onSaved;
  final Future<void> Function() saveModeForm;
  final void Function() clearModeInputs;
  final GlobalKey<FormState> modeForm;
  final TextEditingController? ipAddress;
  final TextEditingController? portNum;

  const IPAddressContainer({
    Key? key,
    required this.text,
    required this.validate,
    required this.onSaved,
    required this.ipAddress,
    required this.portNum,
    required this.saveModeForm,
    required this.modeForm,
    required this.clearModeInputs,
  }) : super(key: key);

  @override
  State<IPAddressContainer> createState() => _IPAddressContainerState();
}

class _IPAddressContainerState extends State<IPAddressContainer> {
  @override
  Widget build(BuildContext context) {
    return BorderedContainer(
      child: Form(
        key: widget.modeForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalization.instance.translate(widget.text)),
            const SizedBox(height: 12.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:46,child: Center(child: Text("http:// "),),),
                Expanded(
                  flex: 2,
                  child: FormTextInput(
                    enumerate: ValidEnum.IPADDRESS,
                    context: context,
                    controller: widget.ipAddress,
                    title: AppLocalization.instance.translate("ip_address"),
                    keyboardType: TextInputType.number,
                    validate: (value){
                      return widget.validate(ValidEnum.IPADDRESS, value) == null ? null : widget.validate(ValidEnum.IPADDRESS, value)!;
                    },
                    onSaved: (value){
                      widget.onSaved(value!, ValidEnum.IPADDRESS);
                    },
                  ),
                ),
                Padding(
                  padding: AppSpaces().smallTop,
                  child: const Text(" : "),
                ),
                Expanded(
                  child: FormTextInput(
                    enumerate: ValidEnum.PORT,
                    context: context,
                    controller: widget.portNum,
                    title: AppLocalization.instance.translate("port_num"),
                    keyboardType: TextInputType.number,
                    textInputAction : TextInputAction.done,
                    validate: (value){
                      return widget.validate(ValidEnum.PORT, value) == null ? null : widget.validate(ValidEnum.PORT, value)!;
                    },
                    onSaved: (value){
                      widget.onSaved(value!, ValidEnum.PORT);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                ElevatedButton(
                  child: Text(AppLocalization.instance.translate("reset")),
                  onPressed: () async => widget.clearModeInputs(),
                ),
                const Spacer(),
                ElevatedButton(
                  child: Text(AppLocalization.instance.translate("save")),
                  onPressed: () async => widget.saveModeForm(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

