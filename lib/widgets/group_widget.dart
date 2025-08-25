import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_group.dart';
import 'package:tileseteditor/utils/image_utils.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';

class GroupWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSet tileSet;
  final TileSetGroup group;

  const GroupWidget({super.key, required this.tileSet, required this.group});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 250,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(border: BoxBorder.all(color: Colors.black, strokeAlign: 1.0)),
                child: GridView.count(shrinkWrap: true, crossAxisCount: 4, children: [for (var image in cropTiles(tileSet, group.tileIndices)) image]),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 400,
          child: Column(
            children: [
              AppDialogNumberField(name: 'Key', initialValue: group.key, disabled: true),
              AppDialogTextField(
                name: 'Name',
                initialValue: group.name,
                validationMessage: 'Please enter the name of the Group.',
                onChanged: (String value) {
                  group.name = value;
                },
              ),
              SizedBox(height: space),
              AppDialogNumberField(
                // FIXME: use a drop down list
                name: 'Width',
                initialValue: group.width,
                validationMessage: 'Please define Width of the Group',
                onChanged: (int value) {
                  group.width = value;
                },
              ),
              AppDialogNumberField(
                name: 'Height',
                initialValue: group.height,
                validationMessage: 'Please define Height of the Group',
                onChanged: (int value) {
                  group.height = value;
                },
              ),
              SizedBox(height: space),
              AppDialogTextField(name: 'Tiles (indices)', initialValue: group.tileIndices.join(','), disabled: true),
            ],
          ),
        ),
      ],
    );
  }

  static List<Image> cropTiles(TileSet tileSet, List<int> tileIndices) {
    List<TileCoord> coords = [];
    for (int index in tileIndices) {
      coords.add(tileSet.getTileCoord(index));
    }
    return ImageUtils.cropTiles(tileSet.filePath, coords, tileSet.tileWidth, tileSet.tileHeight);
  }
}
