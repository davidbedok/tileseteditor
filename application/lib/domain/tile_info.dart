import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';

class TileInfo {
  TileCoord coord;
  YateItem tileSetItem;

  TileInfo({required this.tileSetItem, required this.coord});

  @override
  bool operator ==(Object other) => identical(this, other) || (other is TileInfo && runtimeType == other.runtimeType && tileSetItem == other.tileSetItem);

  @override
  int get hashCode => tileSetItem.hashCode;

  @override
  String toString() {
    return '$tileSetItem (coord: $coord)';
  }
}
