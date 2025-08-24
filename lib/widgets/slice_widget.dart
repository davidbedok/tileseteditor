import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';

class SliceWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSetSlice slice;
  final bool edit;

  const SliceWidget({super.key, required this.slice, required this.edit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDialogNumberField(
          name: 'Key',
          initialValue: slice.key,
          validationMessage: '',
          onChanged: (int value) {
            slice.key = value;
          },
        ),
        AppDialogTextField(
          name: 'Name',
          initialValue: slice.name,
          validationMessage: 'Please enter the name of the Slice.',
          onChanged: (String value) {
            slice.name = value;
          },
        ),
        SizedBox(height: space),
        AppDialogNumberField(
          name: 'Left',
          initialValue: slice.left,
          validationMessage: 'Please define Left of the Slice',
          onChanged: (int value) {
            slice.left = value;
          },
        ),
        AppDialogNumberField(
          name: 'Top',
          initialValue: slice.top,
          validationMessage: 'Please define Top of the Slice',
          onChanged: (int value) {
            slice.top = value;
          },
        ),
        AppDialogNumberField(
          name: 'Width',
          initialValue: slice.width,
          validationMessage: 'Please define Width of the Slice',
          onChanged: (int value) {
            slice.width = value;
          },
        ),
        AppDialogNumberField(
          name: 'Height',
          initialValue: slice.height,
          validationMessage: 'Please define Height of the Slice',
          onChanged: (int value) {
            slice.height = value;
          },
        ),
      ],
    );
  }
}
