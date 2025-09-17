import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';

class TileInfo {
  TileCoord coord;
  YateItem item;

  TileInfo({required this.item, required this.coord});

  @override
  bool operator ==(Object other) => identical(this, other) || (other is TileInfo && runtimeType == other.runtimeType && item == other.item);

  @override
  int get hashCode => item.hashCode;

  @override
  String toString() {
    return '$item (coord: $coord)';
  }
}
