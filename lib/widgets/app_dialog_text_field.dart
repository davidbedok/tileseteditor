import 'package:flutter/material.dart';

class AppDialogTextField extends StatelessWidget {
  final String name;
  final String hint;
  final String? initialValue;
  final bool disabled;
  final String? validationMessage;
  final void Function(String value)? onChanged;

  const AppDialogTextField({
    super.key, //
    required this.name,
    this.hint = '',
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
                decoration: InputDecoration.collapsed(hintText: hint),
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
          ),
        ),
      ],
    );
  }
}
