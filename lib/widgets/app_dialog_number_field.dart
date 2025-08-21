import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppDialogNumberField extends StatelessWidget {
  final String name;
  final int? initialValue;
  final String validationMessage;
  final void Function(int value) onChanged;

  const AppDialogNumberField({super.key, required this.name, required this.initialValue, required this.validationMessage, required this.onChanged});

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
            onChanged: (String value) {
              int parsedValue = int.tryParse(value) ?? 0;
              onChanged.call(parsedValue);
            },
            validator: (value) => value!.isEmpty ? validationMessage : null,
          ),
        ),
      ],
    );
  }
}
