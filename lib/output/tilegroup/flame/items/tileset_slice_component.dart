import 'package:flame/components.dart';
import 'package:tileseteditor/domain/items/tileset_slice.dart';
import 'package:tileseteditor/output/tilegroup/flame/items/yate_component.dart';

class TileSetSliceComponent extends YateComponent {
  TileSetSlice getSlice() => tileSetItem as TileSetSlice;

  TileSetSliceComponent({
    required super.position,
    required super.tileSet, //
    required super.originalPosition,
    required super.external,
    required TileSetSlice slice,
  }) : super(tileSetItem: slice, areaSize: slice.size);

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
