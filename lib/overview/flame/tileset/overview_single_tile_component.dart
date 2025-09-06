import 'package:flame/components.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_tile.dart';
import 'package:tileseteditor/overview/flame/overview_tile_component.dart';
import 'package:tileseteditor/overview/flame/tileset/overview_tileset_component.dart';

class OverviewSingleTileComponent extends OverviewTileSetComponent {
  TileSetTile getTile() => tileSetItem as TileSetTile;

  OverviewSingleTileComponent({
    required super.position, //
    required super.tileSet,
    required super.originalPosition,
    required super.external,
    required TileSetTile tile,
  }) : super(tileSetItem: tile, areaSize: TileRectSize(1, 1));

  @override
  void placeOutput(OverviewTileComponent topLeftTile) {
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
