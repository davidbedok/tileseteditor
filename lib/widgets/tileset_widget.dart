import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_switch_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';
import 'package:path/path.dart' as path;

class TileSetWidget extends StatefulWidget {
  static final double space = 8.0;

  final TileSetProject project;
  final TileSet tileSet;
  final bool edit;

  const TileSetWidget({super.key, required this.project, required this.tileSet, required this.edit});

  @override
  State<TileSetWidget> createState() => _TileSetWidgetState();
}

class _TileSetWidgetState extends State<TileSetWidget> {
  bool active = false;
  final sourceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    active = widget.tileSet.active;
    sourceController.text = widget.tileSet.filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDialogTextField(
          name: 'Name',
          initialValue: widget.tileSet.name,
          validationMessage: 'Please enter the name of the TileSet.',
          onChanged: (String value) {
            widget.tileSet.name = value;
          },
        ),
        SizedBox(height: TileSetWidget.space),
        AppDialogSwitchField(
          name: 'Active',
          initialValue: active,
          disabled: false,
          onChanged: (bool value) {
            setState(() {
              active = value;
            });
            widget.tileSet.active = value;
          },
        ),
        SizedBox(height: TileSetWidget.space),
        Visibility(
          visible: !widget.edit,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
        ),
        SizedBox(height: TileSetWidget.space),
        AppDialogNumberField(name: 'Tile width (same as output)', initialValue: widget.tileSet.tileSize.widthPx, disabled: true),
        AppDialogNumberField(name: 'Tile height (same as output)', initialValue: widget.tileSet.tileSize.heightPx, disabled: true),
        SizedBox(height: TileSetWidget.space),
        AppDialogNumberField(name: 'Margin (not yet supported)', initialValue: widget.tileSet.margin, disabled: true),
        AppDialogNumberField(name: 'Spacing (not yet supported)', initialValue: widget.tileSet.spacing, disabled: true),
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
      widget.tileSet.filePath = path.relative(sourceController.text, from: widget.project.getDirectory());
    }
  }
}
