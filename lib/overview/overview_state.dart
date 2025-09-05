import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/event/custom_event.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class OverviewState {
  late ObjectLevelEvent<OverviewState, TileSetItem> tileSetItem;
  late CustomEvent<OverviewState> removeAll;

  OverviewState() {
    tileSetItem = ObjectLevelEvent(state: this, noneObject: TileSetItem.none);
    removeAll = CustomEvent(state: this);
  }
}
