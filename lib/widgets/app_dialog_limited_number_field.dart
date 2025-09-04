import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppDialogLimitedNumberField extends StatelessWidget {
  final String name;
  final int? initialValue;
  final bool disabled;
  final int minValue;
  final int maxValue;
  final String? validationEmptyMessage;
  final String? validationLimitMessage;
  final void Function(int value)? onChanged;

  const AppDialogLimitedNumberField({
    super.key, //
    required this.name,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    this.validationEmptyMessage,
    this.validationLimitMessage,
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
            validator: (String? value) {
              String? result;
              if (value!.isEmpty || value.trim().isEmpty) {
                result = validationEmptyMessage;
              } else {
                int parsedValue = int.tryParse(value) ?? 0;
                if (parsedValue < minValue || parsedValue > maxValue) {
                  result = validationLimitMessage;
                }
              }
              return result;
            },
          ),
        ),
      ],
    );
  }
}
