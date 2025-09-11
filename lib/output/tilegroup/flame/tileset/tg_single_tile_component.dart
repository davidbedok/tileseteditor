import 'package:flame/components.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_tile.dart';
import 'package:tileseteditor/output/tilegroup/flame/tilegroup_output_tile_component.dart';
import 'package:tileseteditor/output/tilegroup/flame/tileset/tg_tileset_component.dart';

class TgSingleTileComponent extends TgTileSetComponent {
  TileSetTile getTile() => tileSetItem as TileSetTile;

  TgSingleTileComponent({
    required super.position, //
    required super.tileSet,
    required super.originalPosition,
    required super.external,
    required TileSetTile tile,
  }) : super(tileSetItem: tile, areaSize: TileRectSize(1, 1));

  @override
  void placeOutput(TileGroupOutputTileComponent topLeftTile) {
    tileSetItem.output = topLeftTile.getCoord();
    tileSet.addTile(getTile());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(
      tileSet.image!, //
      srcPosition: tileSetItem.getRealPosition(tileWidth, tileHeight),
      srcSize: tileSetItem.getRealSize(tileWidth, tileHeight),
    );
    size = tileSetItem.getRealSize(tileWidth, tileHeight);
    // debugMode = true;
  }
}
