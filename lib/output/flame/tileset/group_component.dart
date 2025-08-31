import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_group.dart';
import 'package:tileseteditor/output/flame/tileset/tileset_component.dart';

class GroupComponent extends TileSetComponent {
  TileSetGroup getGroup() => tileSetItem as TileSetGroup;

  GroupComponent({
    required super.position,
    required super.tileSet, //
    required super.originalPosition,
    required super.external,
    required TileSetGroup group,
  }) : super(tileSetItem: group, areaSize: group.size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    TileSetGroup group = getGroup();

    ImageComposition composition = ImageComposition();
    int tileIndex = 0;
    for (int j = 0; j < group.size.height; j++) {
      for (int i = 0; i < group.size.width; i++) {
        if (tileIndex < group.tileIndices.length) {
          int index = group.tileIndices[tileIndex];
          TileCoord tileCoord = tileSet.getTileCoord(index);
          Sprite tmpSprite = Sprite(
            tileSet.image!,
            srcPosition: Vector2((tileCoord.left - 1) * tileWidth, (tileCoord.top - 1) * tileHeight),
            srcSize: Vector2(tileWidth, tileHeight),
          );

          composition.add(tmpSprite.toImageSync(), Vector2(i * tileWidth.toDouble(), j * tileHeight.toDouble()));
          tileIndex++;
        }
      }
    }

    dui.Image compositeImage = await composition.compose();
    sprite = Sprite(
      compositeImage, //
      srcPosition: Vector2(0, 0),
      srcSize: Vector2(group.size.width * tileWidth, group.size.height * tileHeight),
    );
    size = group.getRealSize(tileWidth, tileHeight);
    // debugMode = true;
  }
}
