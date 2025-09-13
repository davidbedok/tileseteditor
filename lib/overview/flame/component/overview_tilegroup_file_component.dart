import 'package:flame/components.dart';
import 'package:tileseteditor/domain/items/tilegroup_file.dart';
import 'package:tileseteditor/overview/flame/component/overview_yate_component.dart';

class OverviewTileGroupFileComponent extends OverviewYateComponent {
  TileGroupFile getFile() => item as TileGroupFile;

  OverviewTileGroupFileComponent({
    required super.position,
    required super.projectItem, //
    required super.originalPosition,
    required super.external,
    required TileGroupFile file,
  }) : super(item: file, areaSize: file.size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(
      getFile().image!, //
      srcPosition: item.getRealPosition(tileWidth, tileHeight),
      srcSize: item.getRealSize(tileWidth, tileHeight),
    );
    size = item.getRealSize(tileWidth, tileHeight);
    // debugMode = true;
  }
}
