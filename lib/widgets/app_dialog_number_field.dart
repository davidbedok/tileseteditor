import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppDialogNumberField extends StatelessWidget {
  final String name;
  final int? initialValue;
  final bool disabled;
  final String? validationMessage;
  final void Function(int value)? onChanged;

  const AppDialogNumberField({super.key, required this.name, required this.initialValue, this.validationMessage, this.onChanged, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(name, style: Theme.of(context).textTheme.bodyMedium)),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: false, signed: true),
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            initialValue: initialValue?.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            readOnly: disabled,
            onChanged: disabled
                ? null
                : (String value) {
                    if (onChanged != null) {
                      int parsedValue = int.tryParse(value) ?? 0;
                      onChanged!.call(parsedValue);
                    }
                  },
            validator: (value) => value!.isEmpty || value.trim().isEmpty ? validationMessage : null,
          ),
        ),
      ],
    );
  }
}
