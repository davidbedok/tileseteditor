import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_area_size.dart';

class AppDialogNamedAreaSizeField extends StatelessWidget {
  final String name;
  final int numberOfTiles;
  final TileSetAreaSize initialValue;
  final String validationMessage;
  final bool edit;
  final void Function(TileSetAreaSize value) onChanged;

  const AppDialogNamedAreaSizeField({
    super.key,
    required this.name,
    required this.numberOfTiles,
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
        Flexible(child: Text(name, style: Theme.of(context).textTheme.bodyMedium)),
        Expanded(
          child: DropdownButtonFormField<TileSetAreaSize>(
            value: initialValue,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(border: InputBorder.none),
            isExpanded: true,
            items: TileSetAreaSize.options(numberOfTiles).map((TileSetAreaSize size) {
              return DropdownMenuItem<TileSetAreaSize>(value: size, child: Text('${size.width} x ${size.height}'));
            }).toList(),
            onChanged: edit
                ? (value) {
                    onChanged.call(value!);
                  }
                : null,
            validator: (value) => value == null ? validationMessage : null,
          ),
        ),
      ],
    );
  }
}
