import 'package:flame/components.dart';
import 'package:tileseteditor/domain/items/tileset_slice.dart';
import 'package:tileseteditor/output/flame/component/yate_component.dart';

class TileSetSliceComponent extends YateComponent {
  TileSetSlice getSlice() => item as TileSetSlice;

  TileSetSliceComponent({
    required super.position,
    required super.projectItem, //
    required super.originalPosition,
    required super.external,
    required TileSetSlice slice,
  }) : super(item: slice, areaSize: slice.size);

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
