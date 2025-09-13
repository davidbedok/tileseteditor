import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/items/tileset_group.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/widgets/app_dialog_widget.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/widgets/group_widget.dart';

class AddGroupDialog extends StatefulWidget {
  final YateProject project;
  final TileSet tileSet;
  final List<TileCoord> tiles;

  const AddGroupDialog({super.key, required this.project, required this.tileSet, required this.tiles});

  @override
  AddGroupDialogState createState() => AddGroupDialogState();
}

class AddGroupDialogState extends State<AddGroupDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  late TileSetGroup _group;

  @override
  void initState() {
    super.initState();
    _group = TileSetGroup(
      id: widget.tileSet.getNextGroupId(), //
      name: '',
      size: TileRectSize(1, widget.tiles.length),
    );
    for (TileCoord coord in widget.tiles) {
      _group.tileIndices.add(widget.tileSet.getIndex(coord));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogWidget(
      formKey: _formKey,
      title: 'Add new Group to ${widget.tileSet.name} TileSet',
      width: 800,
      actionButton: 'Add',
      onAction: () {
        Navigator.of(context).pop(_group);
      },
      children: [GroupWidget(group: _group, project: widget.project, tileSet: widget.tileSet)],
    );
  }
}
