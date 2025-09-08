import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/widgets/app_dialog_widget.dart';
import 'package:tileseteditor/widgets/tilegroup_widget.dart';

class AddTileGroupDialog extends StatefulWidget {
  final TileSetProject project;

  const AddTileGroupDialog({super.key, required this.project});

  @override
  AddTileGroupDialogState createState() => AddTileGroupDialogState();
}

class AddTileGroupDialogState extends State<AddTileGroupDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  late TileGroup _tileGroup;

  @override
  void initState() {
    super.initState();
    _tileGroup = TileGroup(
      id: widget.project.getNextTileGroupId(),
      name: '',
      active: true,
      tileSize: PixelSize(widget.project.output.tileSize.widthPx, widget.project.output.tileSize.heightPx),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogWidget(
      formKey: _formKey,
      title: 'Add new TileGroup to ${widget.project.name} project',
      actionButton: 'Add',
      onAction: () {
        Navigator.of(context).pop(_tileGroup);
      },
      children: [TileGroupWidget(project: widget.project, tileGroup: _tileGroup, edit: false)],
    );
  }
}
