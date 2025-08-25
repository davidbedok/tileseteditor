import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';
import 'package:tileseteditor/widgets/app_dialog_tile_size_field.dart';

class TileSetWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSet tileSet;
  final bool edit;

  final sourceController = TextEditingController();

  TileSetWidget({super.key, required this.tileSet, required this.edit});

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Source", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: TextFormField(
                controller: sourceController,
                style: Theme.of(context).textTheme.bodyMedium,
                readOnly: true,
                validator: (value) => value!.isEmpty ? 'Please select a tileset image' : null,
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  browseTileSet();
                },
                child: const Text('Browse'),
              ),
            ),
          ],
        ),
        SizedBox(height: space),
        AppDialogTileSizeField(
          name: 'Tile width',
          initialValue: tileSet.tileWidth,
          validationMessage: 'Please choose tile width',
          edit: edit,
          onChanged: (int value) {
            tileSet.tileWidth = value;
          },
        ),
        AppDialogTileSizeField(
          name: 'Tile height',
          initialValue: tileSet.tileHeight,
          validationMessage: 'Please choose tile height',
          edit: edit,
          onChanged: (int value) {
            tileSet.tileHeight = value;
          },
        ),
        SizedBox(height: space),
        AppDialogNumberField(
          name: 'Margin',
          initialValue: tileSet.margin,
          validationMessage: 'Please define Margin of the TileSet',
          onChanged: (int value) {
            tileSet.margin = value;
          },
        ),
        AppDialogNumberField(
          name: 'Spacing',
          initialValue: tileSet.spacing,
          validationMessage: 'Please define Spacing of the TileSet',
          onChanged: (int value) {
            tileSet.spacing = value;
          },
        ),
      ],
    );
  }

  void browseTileSet() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['png'],
      dialogTitle: 'Open TileSet',
      type: FileType.image,
    );
    if (filePickerResult != null) {
      sourceController.text = filePickerResult.files.single.path!;
      tileSet.filePath = sourceController.text;
    }
  }
}
