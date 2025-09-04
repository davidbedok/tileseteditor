import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_switch_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';
import 'package:path/path.dart' as path;

class TileSetWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSetProject project;
  final TileSet tileSet;
  final bool edit;

  final sourceController = TextEditingController();

  TileSetWidget({super.key, required this.project, required this.tileSet, required this.edit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDialogTextField(
          name: 'Name',
          initialValue: tileSet.name,
          validationMessage: 'Please enter the name of the TileSet.',
          onChanged: (String value) {
            tileSet.name = value;
          },
        ),
        SizedBox(height: space),
        AppDialogSwitchField(
          name: 'Active',
          initialValue: tileSet.active,
          disabled: false,
          onChanged: (bool value) {
            tileSet.active = value;
          },
        ),
        SizedBox(height: space),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Flexible(child: Text("Source", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: ElevatedButton(
                  onPressed: () {
                    browseTileSet();
                  },
                  child: const Text('Choose TileSet image (*.png)'),
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: sourceController,
                style: Theme.of(context).textTheme.bodyMedium,
                readOnly: true,
                validator: (value) => value!.isEmpty ? 'Please select a tileset image' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: space),
        AppDialogNumberField(name: 'Tile width (same as output)', initialValue: tileSet.tileWidth, disabled: true),
        AppDialogNumberField(name: 'Tile height (same as output)', initialValue: tileSet.tileHeight, disabled: true),
        SizedBox(height: space),
        AppDialogNumberField(name: 'Margin (not yet supported)', initialValue: tileSet.margin, disabled: true),
        AppDialogNumberField(name: 'Spacing (not yet supported)', initialValue: tileSet.spacing, disabled: true),
      ],
    );
  }

  void browseTileSet() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['png'],
      dialogTitle: 'Open TileSet',
      type: FileType.custom,
      lockParentWindow: true,
    );
    if (filePickerResult != null) {
      sourceController.text = filePickerResult.files.single.path!;
      tileSet.filePath = path.relative(sourceController.text, from: project.getDirectory());
    }
  }
}
