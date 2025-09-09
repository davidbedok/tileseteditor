import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/widgets/app_dialog_widget.dart';
import 'package:tileseteditor/widgets/tileset_widget.dart';

class EditTileSetDialog extends StatefulWidget {
  final TileSetProject project;
  final TileSet tileSet;

  const EditTileSetDialog({
    super.key, //
    required this.project,
    required this.tileSet,
  });

  @override
  EditTileSetDialogState createState() => EditTileSetDialogState();
}

class EditTileSetDialogState extends State<EditTileSetDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppDialogWidget(
      formKey: _formKey,
      title: 'Edit TileSet',
      width: 800,
      actionButton: 'Modify',
      onAction: () {
        Navigator.of(context).pop(widget.tileSet);
      },
      children: [
        TileSetWidget(
          project: widget.project, //
          tileSet: widget.tileSet,
          edit: true,
        ),
      ],
    );
  }
}
