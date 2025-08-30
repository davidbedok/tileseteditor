import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/widgets/app_dialog_widget.dart';
import 'package:tileseteditor/widgets/tileset_widget.dart';

class AddTileSetDialog extends StatefulWidget {
  final TileSetProject project;

  const AddTileSetDialog({super.key, required this.project});

  @override
  AddTileSetDialogState createState() => AddTileSetDialogState();
}

class AddTileSetDialogState extends State<AddTileSetDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  late TileSet _tileSet;

  @override
  void initState() {
    super.initState();
    _tileSet = TileSet(
      key: widget.project.getNextTileSetKey(),
      name: '',
      filePath: '',
      tileWidth: widget.project.output.tileWidth,
      tileHeight: widget.project.output.tileHeight,
      margin: 0,
      spacing: 0,
      imageWidth: 0,
      imageHeight: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogWidget(
      formKey: _formKey,
      title: 'Add TileSet',
      actionButton: 'Add',
      onAction: () {
        Navigator.of(context).pop(_tileSet);
      },
      children: [TileSetWidget(project: widget.project, tileSet: _tileSet, edit: false)],
    );
  }
}
