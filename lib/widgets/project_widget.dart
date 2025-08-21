import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
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
          name: 'Tile width',
          initialValue: project.tileWidth,
          validationMessage: 'Please choose tile width',
          edit: edit,
          onChanged: (int value) {
            project.tileWidth = value;
          },
        ),
        SizedBox(height: space),
        AppDialogTileSizeField(
          name: 'Tile height',
          initialValue: project.tileHeight,
          validationMessage: 'Please choose tile height',
          edit: edit,
          onChanged: (int value) {
            project.tileHeight = value;
          },
        ),
      ],
    );
  }
}
