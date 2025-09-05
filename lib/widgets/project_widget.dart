import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_output.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/widgets/app_dialog_limited_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';
import 'package:tileseteditor/widgets/app_dialog_tile_size_field.dart';

class ProjectWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSetProject project;
  final bool edit;

  const ProjectWidget({super.key, required this.project, required this.edit});

  @override
  Widget build(BuildContext context) {
    int maxOutputLeft = project.getMaxOutputLeft(TileSetOutput.minOutputWidth);
    int maxOutputTop = project.getMaxOutputTop(TileSetOutput.minOutputHeight);

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
        AppDialogTextField(
          name: 'Output file',
          initialValue: project.output.fileName,
          validationMessage: 'Please enter the file name of the output (*.png)',
          onChanged: (String value) {
            project.output.fileName = value;
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
        AppDialogLimitedNumberField(
          name: 'Output width ($maxOutputLeft..${TileSetOutput.maxOutputWidth})',
          initialValue: project.output.width,
          minValue: maxOutputLeft,
          maxValue: TileSetOutput.maxOutputWidth,
          onChanged: (int value) {
            project.output.width = value;
          },
          validationEmptyMessage: 'Please define the output width',
          validationLimitMessage: 'Output width must be between $maxOutputLeft and ${TileSetOutput.maxOutputWidth}',
        ),
        SizedBox(height: space),
        AppDialogLimitedNumberField(
          name: 'Output height ($maxOutputTop..${TileSetOutput.maxOutputHeight})',
          initialValue: project.output.height,
          minValue: maxOutputTop,
          maxValue: TileSetOutput.maxOutputHeight,
          onChanged: (int value) {
            project.output.height = value;
          },
          validationEmptyMessage: 'Please define the output height',
          validationLimitMessage: 'Output height must be between $maxOutputTop and ${TileSetOutput.maxOutputHeight}',
        ),
      ],
    );
  }
}
