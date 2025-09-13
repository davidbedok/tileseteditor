import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/widgets/app_dialog_widget.dart';
import 'package:tileseteditor/widgets/tileset_widget.dart';

class AddTileSetDialog extends StatefulWidget {
  final YateProject project;

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
      id: widget.project.getNextTileSetId(),
      key: widget.project.getNextKey(),
      name: '',
      active: true,
      filePath: '',
      tileSize: PixelSize(widget.project.output.tileSize.widthPx, widget.project.output.tileSize.heightPx),
      margin: 0,
      spacing: 0,
      imageSize: PixelSize(0, 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogWidget(
      formKey: _formKey,
      title: 'Add new TileSet to ${widget.project.name} project',
      width: 800,
      actionButton: 'Add',
      onAction: () {
        Navigator.of(context).pop(_tileSet);
      },
      children: [TileSetWidget(project: widget.project, tileSet: _tileSet, edit: false)],
    );
  }
}
