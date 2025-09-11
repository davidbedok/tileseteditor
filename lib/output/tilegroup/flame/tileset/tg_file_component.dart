import 'package:flame/components.dart';
import 'package:tileseteditor/domain/tilesetitem/tilegroup_file.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_slice.dart';
import 'package:tileseteditor/output/tilegroup/flame/tileset/tg_tileset_component.dart';

class TgFileComponent extends TgTileSetComponent {
  TileGroupFile getFile() => tileSetItem as TileGroupFile;

  TgFileComponent({
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
