import 'package:flutter/material.dart';

class AppDialogTextAreaField extends StatelessWidget {
  final String hint;
  final String? initialValue;
  final bool disabled;
  final String? validationMessage;
  final void Function(String value)? onChanged;

  const AppDialogTextAreaField({
    super.key, //
    required this.hint,
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
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration.collapsed(hintText: hint),
                maxLines: 5,
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
