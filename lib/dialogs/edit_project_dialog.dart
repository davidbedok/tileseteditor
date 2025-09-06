import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/widgets/app_dialog_widget.dart';
import 'package:tileseteditor/widgets/project_widget.dart';

class EditProjectDialog extends StatefulWidget {
  final TileSetProject project;

  const EditProjectDialog({super.key, required this.project});

  @override
  EditProjectDialogState createState() => EditProjectDialogState();
}

class EditProjectDialogState extends State<EditProjectDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppDialogWidget(
      formKey: _formKey,
      title: 'Edit Project',
      actionButton: 'Modify',
      onAction: () {
        Navigator.of(context).pop(widget.project);
      },
      children: [ProjectWidget(project: widget.project, edit: true)],
    );
  }
}
