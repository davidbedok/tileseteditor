import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/event/custom_event.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class OutputState {
  late ObjectLevelEvent<OutputState, YateItem> yateItem;
  late CustomEvent<OutputState> removeAll;

  OutputState() {
    yateItem = ObjectLevelEvent(state: this, noneObject: YateItem.none);
    removeAll = CustomEvent(state: this);
  }
}
