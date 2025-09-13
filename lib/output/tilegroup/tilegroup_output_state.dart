import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/event/custom_event.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class TileGroupOutputState {
  late ObjectLevelEvent<TileGroupOutputState, YateItem> yateItem;
  late CustomEvent<TileGroupOutputState> removeAll;

  TileGroupOutputState() {
    yateItem = ObjectLevelEvent(state: this, noneObject: YateItem.none);
    removeAll = CustomEvent(state: this);
  }
}
