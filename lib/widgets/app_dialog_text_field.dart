import 'package:flutter/material.dart';

class AppDialogTextField extends StatelessWidget {
  final String name;
  final String? initialValue;
  final bool disabled;
  final String? validationMessage;
  final void Function(String value)? onChanged;

  const AppDialogTextField({
    super.key, //
    required this.name,
    required this.initialValue,
    this.validationMessage,
    this.onChanged,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(name, style: Theme.of(context).textTheme.bodyMedium)),
        Expanded(
          child: TextFormField(
            initialValue: initialValue,
            style: Theme.of(context).textTheme.bodyMedium,
            readOnly: disabled,
            onChanged: disabled
                ? null
                : (value) {
                    if (onChanged != null) {
                      onChanged!.call(value.trim());
                    }
                  },
            validator: (value) => value!.isEmpty || value.trim().isEmpty ? validationMessage : null,
          ),
        ),
      ],
    );
  }
}
