import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/event/custom_event.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class TileSetOutputState {
  late ObjectLevelEvent<TileSetOutputState, TileSetItem> tileSetItem;
  late CustomEvent<TileSetOutputState> removeAll;

  TileSetOutputState() {
    tileSetItem = ObjectLevelEvent(state: this, noneObject: TileSetItem.none);
    removeAll = CustomEvent(state: this);
  }
}
