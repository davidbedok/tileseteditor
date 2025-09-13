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
        Flexible(child: Text(name, style: Theme.of(context).textTheme.labelLarge)),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(3.0),
              color: disabled ? const Color.fromARGB(32, 155, 155, 119) : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration.collapsed(hintText: ''),
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
          ),
        ),
      ],
    );
  }
}
