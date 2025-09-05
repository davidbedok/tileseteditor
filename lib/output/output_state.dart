import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/event/custom_event.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class OutputState {
  late ObjectLevelEvent<OutputState, TileSetItem> tileSetItem;
  late CustomEvent<OutputState> removeAll;

  OutputState() {
    tileSetItem = ObjectLevelEvent(state: this, noneObject: TileSetItem.none);
    removeAll = CustomEvent(state: this);
  }
}
