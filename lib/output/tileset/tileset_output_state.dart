import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/event/custom_event.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class TileSetOutputState {
  late ObjectLevelEvent<TileSetOutputState, YateItem> yateItem;
  late CustomEvent<TileSetOutputState> removeAll;

  TileSetOutputState() {
    yateItem = ObjectLevelEvent(state: this, noneObject: YateItem.none);
    removeAll = CustomEvent(state: this);
  }
}
