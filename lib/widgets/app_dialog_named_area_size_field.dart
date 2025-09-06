import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';

class AppDialogNamedAreaSizeField extends StatelessWidget {
  final String name;
  final int numberOfTiles;
  final TileRectSize initialValue;
  final String validationMessage;
  final bool edit;
  final void Function(TileRectSize value) onChanged;

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
          child: DropdownButtonFormField<TileRectSize>(
            value: initialValue,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(border: InputBorder.none),
            isExpanded: true,
            items: TileRectSize.options(numberOfTiles).map((TileRectSize size) {
              return DropdownMenuItem<TileRectSize>(value: size, child: Text('${size.width} x ${size.height}'));
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
