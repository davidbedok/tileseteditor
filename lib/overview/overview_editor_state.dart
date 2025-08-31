import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';

class OverviewEditorState {
  TileSetItem? selectedItem;

  List<void Function(TileSetItem tileSetItem)> onRemovedEventHandlers = [];
  List<void Function()> onRemovedAllEventHandlers = [];
  List<void Function(OverviewEditorState state, TileSetItem? tileSetItem)> onSelectedEventHandlers = [];

  OverviewEditorState();

  void subscribeOnSelected(void Function(OverviewEditorState state, TileSetItem? tileSetItem) eventHandler) {
    onSelectedEventHandlers.add(eventHandler);
  }

  void unsubscribeOnSelected(void Function(OverviewEditorState state, TileSetItem? tileSetItem) eventHandler) {
    onSelectedEventHandlers.remove(eventHandler);
  }

  void subscribeOnRemoved(void Function(TileSetItem tileSetItem) eventHandler) {
    onRemovedEventHandlers.add(eventHandler);
  }

  void unsubscribeOnRemoved(void Function(TileSetItem tileSetItem) eventHandler) {
    onRemovedEventHandlers.remove(eventHandler);
  }

  void subscribeOnRemovedAll(void Function() eventHandler) {
    onRemovedAllEventHandlers.add(eventHandler);
  }

  void unsubscribeOnRemovedAll(void Function() eventHandler) {
    onRemovedAllEventHandlers.remove(eventHandler);
  }

  void select(TileSetItem? tileSetItem) {
    selectedItem = tileSetItem;
    for (var eventHandler in onSelectedEventHandlers) {
      eventHandler.call(this, tileSetItem);
    }
  }

  void remove() {
    if (selectedItem != null) {
      for (var eventHandler in onRemovedEventHandlers) {
        eventHandler.call(selectedItem!);
      }
    }
  }

  void removeAll() {
    for (var eventHandler in onRemovedAllEventHandlers) {
      eventHandler.call();
    }
    select(null);
  }
}
