import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/tile_indexed_coord.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/items/tileset_group.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/utils/image_utils.dart';
import 'package:tileseteditor/utils/tile_utils.dart';
import 'package:tileseteditor/widgets/app_dialog_named_area_size_field.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';
import 'package:tileseteditor/widgets/group_image_widget.dart';

class GroupWidget extends StatefulWidget {
  static final double space = 8.0;

  final YateProject project;
  final TileSet tileSet;
  final TileSetGroup group;

  const GroupWidget({super.key, required this.project, required this.tileSet, required this.group});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  late int groupWidth;
  List<int> selectedTiles = [];
  List<int> tileIndices = [];

  @override
  void initState() {
    super.initState();
    groupWidth = widget.group.size.width;
    tileIndices = widget.group.tileIndices;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: (groupWidth * 32 - 30) < 250 ? groupWidth * 32 + 30 : 250,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(border: BoxBorder.all(color: Colors.black, strokeAlign: 1.0)),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: groupWidth,
                  padding: EdgeInsets.zero,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1,
                  mainAxisSpacing: 0,
                  addSemanticIndexes: true,
                  children: [for (var image in cropTiles(widget.tileSet, tileIndices, selectedTiles)) image],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 500,
          child: Column(
            children: [
              AppDialogNumberField(name: 'ID', initialValue: widget.group.id, disabled: true),
              SizedBox(height: GroupWidget.space),
              AppDialogTextField(
                name: 'Group name',
                hint: 'Enter the name of this group',
                initialValue: widget.group.name,
                validationMessage: 'Please enter the name of the Group.',
                onChanged: (String value) {
                  widget.group.name = value;
                },
              ),
              SizedBox(height: GroupWidget.space),
              AppDialogNamedAreaSizeField(
                name: 'Size (width x height)',
                edit: true,
                numberOfTiles: tileIndices.length,
                initialValue: widget.group.size,
                validationMessage: 'Please define Width of the Group',
                onChanged: (TileRectSize size) {
                  widget.group.size = size;
                  setState(() {
                    groupWidth = size.width;
                  });
                },
              ),
              SizedBox(height: GroupWidget.space),
              AppDialogTextField(key: GlobalKey(), name: 'Tiles (indices)', initialValue: tileIndices.join(','), disabled: true),
              SizedBox(height: GroupWidget.space),
              ElevatedButton(
                onPressed: selectedTiles.length > 1
                    ? () {
                        setState(() {
                          TileUtils.swapTiles(tileIndices, selectedTiles[0], selectedTiles[1]);
                          widget.group.tileIndices = tileIndices;
                          selectedTiles.clear();
                        });
                      }
                    : null,
                child: Text('Swap selected tiles'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<GroupImageWidget> cropTiles(TileSet tileSet, List<int> tileIndices, List<int> selectedTiles) {
    List<TileIndexedCoord> coords = [];
    for (int index in tileIndices) {
      coords.add(tileSet.getTileIndexedCoord(index));
    }
    return ImageUtils.cropTiles(
      widget.project.getTileSetPath(tileSet), //
      coords,
      tileSet.tileSize.widthPx,
      tileSet.tileSize.heightPx,
      selectTile,
      selectedTiles,
    );
  }

  void selectTile(bool selected, int tileIndex) {
    setState(() {
      if (selectedTiles.contains(tileIndex)) {
        selectedTiles.remove(tileIndex);
      } else {
        if (selectedTiles.length < 2) {
          selectedTiles.add(tileIndex);
        }
      }
    });
  }
}
