import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/event/custom_event.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class OverviewState {
  late ObjectLevelEvent<OverviewState, YateItem> tileSetItem;
  late CustomEvent<OverviewState> removeAll;

  OverviewState() {
    tileSetItem = ObjectLevelEvent(state: this, noneObject: YateItem.none);
    removeAll = CustomEvent(state: this);
  }
}
