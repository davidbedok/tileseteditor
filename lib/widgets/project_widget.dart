import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/output/tileset_output.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/widgets/app_dialog_limited_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';
import 'package:tileseteditor/widgets/app_dialog_textarea_field.dart';
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
          name: 'Version',
          initialValue: project.version,
          validationMessage: 'Please enter the version of the Project.',
          onChanged: (String value) {
            project.version = value;
          },
        ),
        SizedBox(height: space),
        AppDialogTextField(
          name: 'Name',
          hint: 'Enter the name of the project..',
          initialValue: project.name,
          validationMessage: 'Please enter the name of the Project.',
          onChanged: (String value) {
            project.name = value;
          },
        ),
        SizedBox(height: space),
        AppDialogTextField(
          name: 'Creator',
          hint: 'Creator\'s name or email',
          initialValue: project.creator,
          validationMessage: 'Please provide some information about the creator',
          onChanged: (String value) {
            project.creator = value;
          },
        ),
        SizedBox(height: space),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: BoxDecoration(
                border: BoxBorder.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(3.0),
                color: const Color.fromARGB(37, 203, 218, 231),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
                child: Column(
                  children: [
                    SizedBox(height: space),
                    AppDialogTextField(
                      name: 'File name (*.png)',
                      hint: 'TileSet image name..',
                      initialValue: project.output.fileName,
                      validationMessage: 'Please enter the file name of the output (*.png)',
                      onChanged: (String value) {
                        project.output.fileName = value;
                      },
                    ),
                    SizedBox(height: space),
                    AppDialogTileSizeField(
                      name: 'Tile width',
                      initialValue: project.output.tileSize.widthPx,
                      validationMessage: 'Please choose tile width',
                      edit: edit,
                      onChanged: (int value) {
                        project.output.tileSize.widthPx = value;
                      },
                    ),
                    SizedBox(height: space),
                    AppDialogTileSizeField(
                      name: 'Tile height',
                      initialValue: project.output.tileSize.heightPx,
                      validationMessage: 'Please choose tile height',
                      edit: edit,
                      onChanged: (int value) {
                        project.output.tileSize.heightPx = value;
                      },
                    ),
                    SizedBox(height: space),
                    AppDialogLimitedNumberField(
                      name: 'Width (from $maxOutputLeft to ${TileSetOutput.maxOutputWidth} tiles)',
                      initialValue: project.output.size.width,
                      minValue: maxOutputLeft,
                      maxValue: TileSetOutput.maxOutputWidth,
                      onChanged: (int value) {
                        project.output.size.width = value;
                      },
                      validationEmptyMessage: 'Please define the output width',
                      validationLimitMessage: 'Output width must be between $maxOutputLeft and ${TileSetOutput.maxOutputWidth}',
                    ),
                    SizedBox(height: space),
                    AppDialogLimitedNumberField(
                      name: 'Height (from $maxOutputTop to ${TileSetOutput.maxOutputHeight} tiles)',
                      initialValue: project.output.size.height,
                      minValue: maxOutputTop,
                      maxValue: TileSetOutput.maxOutputHeight,
                      onChanged: (int value) {
                        project.output.size.height = value;
                      },
                      validationEmptyMessage: 'Please define the output height',
                      validationLimitMessage: 'Output height must be between $maxOutputTop and ${TileSetOutput.maxOutputHeight}',
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text('Output TileSet datasheet', style: Theme.of(context).textTheme.labelLarge),
              ),
            ),
          ],
        ),

        SizedBox(height: space),
        AppDialogTextAreaField(
          hint: 'Describe the project here..',
          initialValue: project.description,
          onChanged: (String value) {
            project.description = value;
          },
        ),
      ],
    );
  }
}
