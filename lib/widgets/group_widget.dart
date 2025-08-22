import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_group.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';

class GroupWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSetGroup group;
  final bool edit;

  const GroupWidget({super.key, required this.group, required this.edit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDialogTextField(
          name: 'Name',
          initialValue: group.name,
          validationMessage: 'Please enter the name of the Group.',
          onChanged: (String value) {
            group.name = value;
          },
        ),
        SizedBox(height: space),
        AppDialogTextField(
          name: 'Indices',
          initialValue: group.indices.join(','),
          validationMessage: 'Please all all indices for this Group.',
          onChanged: (String value) {
            // readonly
          },
        ),
        AppDialogNumberField(
          name: 'Width',
          initialValue: group.width,
          validationMessage: 'Please define Width of the Group',
          onChanged: (int value) {
            group.width = value;
          },
        ),
        AppDialogNumberField(
          name: 'Height',
          initialValue: group.height,
          validationMessage: 'Please define Height of the Group',
          onChanged: (int value) {
            group.height = value;
          },
        ),
      ],
    );
  }
}
