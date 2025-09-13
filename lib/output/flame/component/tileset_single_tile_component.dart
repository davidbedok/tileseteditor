import 'package:flame/components.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/items/tileset_tile.dart';
import 'package:tileseteditor/output/flame/component/output_tile_component.dart';
import 'package:tileseteditor/output/flame/component/yate_component.dart';

class TileSetSingleTileComponent extends YateComponent {
  TileSetTile getTile() => item as TileSetTile;

  TileSetSingleTileComponent({
    required super.position, //
    required super.projectItem,
    required super.originalPosition,
    required super.external,
    required TileSetTile tile,
  }) : super(item: tile, areaSize: TileRectSize(1, 1));

  @override
  void placeOutput(OutputTileComponent topLeftTile) {
    item.output = topLeftTile.getCoord();
    getProjectItemAsTileSet().addTile(getTile());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(
      getProjectItemAsTileSet().image!, //
      srcPosition: item.getRealPosition(tileWidth, tileHeight),
      srcSize: item.getRealSize(tileWidth, tileHeight),
    );
    size = item.getRealSize(tileWidth, tileHeight);
    // debugMode = true;
  }
}
