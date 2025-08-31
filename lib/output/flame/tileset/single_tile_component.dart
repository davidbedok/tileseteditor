import 'package:flame/components.dart';
import 'package:tileseteditor/domain/tileset_area_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_tile.dart';
import 'package:tileseteditor/output/flame/output_tile_component.dart';
import 'package:tileseteditor/output/flame/tileset/tileset_component.dart';

class SingleTileComponent extends TileSetComponent {
  TileSetTile getTile() => tileSetItem as TileSetTile;

  SingleTileComponent({
    required super.position, //
    required super.tileSet,
    required super.originalPosition,
    required super.external,
    required TileSetTile tile,
  }) : super(tileSetItem: tile, areaSize: TileSetAreaSize(1, 1));

  @override
  void placeOutput(OutputTileComponent topLeftTile) {
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
