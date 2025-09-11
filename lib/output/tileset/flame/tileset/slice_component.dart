import 'package:flame/components.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_slice.dart';
import 'package:tileseteditor/output/tileset/flame/tileset/tileset_component.dart';

class SliceComponent extends TileSetComponent {
  TileSetSlice getSlice() => tileSetItem as TileSetSlice;

  SliceComponent({
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
