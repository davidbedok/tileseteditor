import 'package:flutter/material.dart';

class AppDialogTextField extends StatelessWidget {
  final String name;
  final String? initialValue;
  final String validationMessage; // TODO optional validator for project.description
  final void Function(String value) onChanged;

  const AppDialogTextField({super.key, required this.name, required this.initialValue, required this.validationMessage, required this.onChanged});

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
            onChanged: onChanged,
            validator: (value) => value!.isEmpty ? validationMessage : null,
          ),
        ),
      ],
    );
  }
}
