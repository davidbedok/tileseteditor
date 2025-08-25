import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppDialogNumberPairField extends StatelessWidget {
  final String name;
  final int? initialValueLeft;
  final int? initialValueRight;
  final bool disabled;
  final String? validationMessage;
  final void Function(int value)? onChangedLeft;
  final void Function(int value)? onChangedRight;

  const AppDialogNumberPairField({
    super.key,
    required this.name,
    required this.initialValueLeft,
    required this.initialValueRight,
    this.validationMessage,
    this.onChangedLeft,
    this.onChangedRight,
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
            keyboardType: TextInputType.numberWithOptions(decimal: false, signed: true),
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            initialValue: initialValueLeft?.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            readOnly: disabled,
            onChanged: disabled
                ? null
                : (String value) {
                    if (onChangedLeft != null) {
                      int parsedValue = int.tryParse(value) ?? 0;
                      onChangedLeft!.call(parsedValue);
                    }
                  },
            validator: (value) => value!.isEmpty || value.trim().isEmpty ? validationMessage : null,
          ),
        ),
        Text('x'),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: false, signed: true),
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            initialValue: initialValueRight?.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            readOnly: disabled,
            onChanged: disabled
                ? null
                : (String value) {
                    if (onChangedRight != null) {
                      int parsedValue = int.tryParse(value) ?? 0;
                      onChangedRight!.call(parsedValue);
                    }
                  },
            validator: (value) => value!.isEmpty || value.trim().isEmpty ? validationMessage : null,
          ),
        ),
      ],
    );
  }
}
