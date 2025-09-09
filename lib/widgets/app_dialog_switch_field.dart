import 'package:flutter/material.dart';

class AppDialogSwitchField extends StatefulWidget {
  final String name;
  final bool initialValue;
  final bool disabled;
  final String? validationMessage;
  final void Function(bool value)? onChanged;

  const AppDialogSwitchField({super.key, required this.name, required this.initialValue, this.validationMessage, this.onChanged, this.disabled = false});

  @override
  State<AppDialogSwitchField> createState() => _AppDialogSwitchFieldState();
}

class _AppDialogSwitchFieldState extends State<AppDialogSwitchField> {
  bool switchValue = false;

  @override
  void initState() {
    super.initState();
    switchValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(widget.name, style: Theme.of(context).textTheme.labelLarge)),
        Switch(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: widget.initialValue, //
          onChanged: widget.disabled
              ? null
              : (bool value) {
                  setState(() {
                    switchValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!.call(value);
                  }
                },
        ),
      ],
    );
  }
}
