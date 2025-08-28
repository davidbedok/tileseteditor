import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';
import 'package:tileseteditor/widgets/app_dialog_tile_size_field.dart';

class ProjectWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSetProject project;
  final bool edit;

  const ProjectWidget({super.key, required this.project, required this.edit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDialogTextField(
          name: 'Name',
          initialValue: project.name,
          validationMessage: 'Please enter the name of the Project.',
          onChanged: (String value) {
            project.name = value;
          },
        ),
        SizedBox(height: space),
        AppDialogTextField(
          name: 'Description',
          initialValue: project.description,
          validationMessage: 'Please enter the description of the Project.',
          onChanged: (String value) {
            project.description = value;
          },
        ),
        SizedBox(height: space),
        AppDialogTileSizeField(
          name: 'Output Tile width',
          initialValue: project.output.tileWidth,
          validationMessage: 'Please choose tile width',
          edit: edit,
          onChanged: (int value) {
            project.output.tileWidth = value;
          },
        ),
        SizedBox(height: space),
        AppDialogTileSizeField(
          name: 'Output Tile height',
          initialValue: project.output.tileHeight,
          validationMessage: 'Please choose tile height',
          edit: edit,
          onChanged: (int value) {
            project.output.tileHeight = value;
          },
        ),
        SizedBox(height: space),
        AppDialogNumberField(
          name: 'Output width',
          initialValue: project.output.width,
          onChanged: (int value) {
            project.output.width = value;
          },
          validationMessage: 'Please define the output width',
        ),
        SizedBox(height: space),
        AppDialogNumberField(
          name: 'Output height',
          initialValue: project.output.height,
          onChanged: (int value) {
            project.output.height = value;
          },
          validationMessage: 'Please define the output height',
        ),
      ],
    );
  }
}
