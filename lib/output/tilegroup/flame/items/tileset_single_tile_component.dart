import 'package:flame/components.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/items/tileset_tile.dart';
import 'package:tileseteditor/output/tilegroup/flame/yate_output_tile_component.dart';
import 'package:tileseteditor/output/tilegroup/flame/items/yate_component.dart';

class TileSetSingleTileComponent extends YateComponent {
  TileSetTile getTile() => tileSetItem as TileSetTile;

  TileSetSingleTileComponent({
    required super.position, //
    required super.projectItem,
    required super.originalPosition,
    required super.external,
    required TileSetTile tile,
  }) : super(tileSetItem: tile, areaSize: TileRectSize(1, 1));

  @override
  void placeOutput(YateOutputTileComponent topLeftTile) {
    tileSetItem.output = topLeftTile.getCoord();
    getProjectItemAsTileSet().addTile(getTile());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(
      getProjectItemAsTileSet().image!, //
      srcPosition: tileSetItem.getRealPosition(tileWidth, tileHeight),
      srcSize: tileSetItem.getRealSize(tileWidth, tileHeight),
    );
    size = tileSetItem.getRealSize(tileWidth, tileHeight);
    // debugMode = true;
  }
}
