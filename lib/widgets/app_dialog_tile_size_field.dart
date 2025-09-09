import 'package:flutter/material.dart';

class AppDialogTileSizeField extends StatelessWidget {
  final String name;
  final int? initialValue;
  final String validationMessage;
  final bool edit;
  final void Function(int value) onChanged;

  static final List<int> _tileSizeOptions = List<int>.generate(41, (i) => i + 10);

  const AppDialogTileSizeField({
    super.key,
    required this.name,
    required this.initialValue,
    required this.edit,
    required this.onChanged,
    required this.validationMessage,
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
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<int>(
                value: initialValue,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration.collapsed(hintText: ''),
                isExpanded: true,
                items: _tileSizeOptions.map((int size) {
                  return DropdownMenuItem<int>(value: size, child: Text(size.toString()));
                }).toList(),
                onChanged: edit
                    ? null
                    : (value) {
                        onChanged.call(value!);
                      },
                validator: (value) => value == null ? validationMessage : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
