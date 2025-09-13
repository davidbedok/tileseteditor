import 'package:tileseteditor/domain/tile_coord.dart';

class TileIndexedCoord extends TileCoord {
  int index;

  TileIndexedCoord(this.index, super.left, super.top);
}
