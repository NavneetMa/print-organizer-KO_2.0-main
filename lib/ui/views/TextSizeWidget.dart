import 'package:flutter/material.dart';
import 'package:kwantapo/ui/widgets/inputs/FormTextInput.dart';
import 'package:kwantapo/ui/widgets/renderers/BorderedContainer.dart';

class TextSizeWidget extends StatefulWidget {
  final TextEditingController textSizeController;
  final Function(double) onTextSizeChange;
  final BuildContext context;

  const TextSizeWidget({
    required this.context,
    required this.textSizeController,
    required this.onTextSizeChange,
  });

  @override
  _TextSizeWidgetState createState() => _TextSizeWidgetState();
}

class _TextSizeWidgetState extends State<TextSizeWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BorderedContainer(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Wrap(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: FormTextInput(
                  context: widget.context,
                  title: "Text Size",
                  controller: widget.textSizeController,
                  enumerate: null,
                  onSaved: (value) {
                  },
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a value';
                    }
                    if (RegExp(r'[^0-9]').hasMatch(value)) {
                      return 'Please enter a valid numeric value';
                    }
                    double? parsedValue = double.tryParse(value);
                    if (parsedValue == null || parsedValue > 100 || parsedValue < 14) {
                      return 'Please enter a value between 14 and 100';
                    }
                    return null;  // Return null if value is valid
                  },
                  keyboardType: TextInputType.number,
                  hintText: "Enter text size:",
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    double value = double.parse(widget.textSizeController.text);
                    widget.onTextSizeChange(value);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
