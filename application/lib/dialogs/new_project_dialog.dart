import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/output/tileset_output.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/widgets/app_dialog_widget.dart';
import 'package:tileseteditor/widgets/project_widget.dart';

class NewProjectDialog extends StatefulWidget {
  const NewProjectDialog({super.key});

  @override
  NewProjectDialogState createState() => NewProjectDialogState();
}

class NewProjectDialogState extends State<NewProjectDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  final YateProject _project = YateProject(
    version: '1.0',
    name: '',
    output: TileSetOutput(
      fileName: '', //
      tileSize: PixelSize(32, 32),
      size: TileRectSize(TileSetOutput.minOutputWidth, TileSetOutput.minOutputHeight),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AppDialogWidget(
      formKey: _formKey,
      title: 'Create new project',
      width: 600,
      actionButton: 'Create',
      onAction: () {
        Navigator.of(context).pop(_project);
      },
      children: [ProjectWidget(project: _project, edit: false)],
    );
  }
}
