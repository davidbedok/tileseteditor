import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_output.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
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

  final TileSetProject _project = TileSetProject(
    name: '',
    output: TileSetOutput(name: '', tileWidth: 32, tileHeight: 32, width: TileSetOutput.minOutputWidth, height: TileSetOutput.minOutputHeight),
  );

  @override
  Widget build(BuildContext context) {
    return AppDialogWidget(
      formKey: _formKey,
      title: 'New Project',
      actionButton: 'Create',
      onAction: () {
        Navigator.of(context).pop(_project);
      },
      children: [ProjectWidget(project: _project, edit: false)],
    );
  }
}
