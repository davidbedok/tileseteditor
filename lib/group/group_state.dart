import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/event/custom_event.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class GroupState {
  late ObjectLevelEvent<GroupState, TileSetItem> tileSetItem;
  late CustomEvent<GroupState> removeAll;

  GroupState() {
    tileSetItem = ObjectLevelEvent(state: this, noneObject: TileSetItem.none);
    removeAll = CustomEvent(state: this);
  }
}
