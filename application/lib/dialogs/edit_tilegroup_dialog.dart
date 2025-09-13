import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/widgets/app_dialog_widget.dart';
import 'package:tileseteditor/widgets/tilegroup_widget.dart';

class EditTileGroupDialog extends StatefulWidget {
  final YateProject project;
  final TileGroup tileGroup;

  const EditTileGroupDialog({
    super.key, //
    required this.project,
    required this.tileGroup,
  });

  @override
  EditTileGroupDialogState createState() => EditTileGroupDialogState();
}

class EditTileGroupDialogState extends State<EditTileGroupDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppDialogWidget(
      formKey: _formKey,
      title: 'Edit TileGroup',
      width: 800,
      actionButton: 'Modify',
      onAction: () {
        Navigator.of(context).pop(widget.tileGroup);
      },
      children: [
        TileGroupWidget(
          project: widget.project, //
          tileGroup: widget.tileGroup,
          edit: true,
        ),
      ],
    );
  }
}
