import 'package:flutter/material.dart';

class AppDialogSwitchField extends StatelessWidget {
  final String name;
  final bool initialValue;
  final bool disabled;
  final String? validationMessage;
  final void Function(bool value)? onChanged;

  const AppDialogSwitchField({super.key, required this.name, required this.initialValue, this.validationMessage, this.onChanged, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(name, style: Theme.of(context).textTheme.bodyMedium)),
        Expanded(
          child: Switch(value: initialValue, onChanged: disabled ? null : onChanged),
        ),
      ],
    );
  }
}
