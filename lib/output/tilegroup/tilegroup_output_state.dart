import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/event/custom_event.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class TileGroupOutputState {
  late ObjectLevelEvent<TileGroupOutputState, YateItem> tileSetItem;
  late CustomEvent<TileGroupOutputState> removeAll;

  TileGroupOutputState() {
    tileSetItem = ObjectLevelEvent(state: this, noneObject: YateItem.none);
    removeAll = CustomEvent(state: this);
  }
}
