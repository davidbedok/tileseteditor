import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';

class OutputEditorState {
  TileSetItem? selectedItem;

  List<void Function(TileSetItem tileSetItem)> onRemovedEventHandlers = [];
  List<void Function(OutputEditorState state, TileSetItem? tileSetItem)> onSelectedEventHandlers = [];

  OutputEditorState();

  void subscribeOnSelected(void Function(OutputEditorState state, TileSetItem? tileSetItem) eventHandler) {
    onSelectedEventHandlers.add(eventHandler);
  }

  void unsubscribeOnSelected(void Function(OutputEditorState state, TileSetItem? tileSetItem) eventHandler) {
    onSelectedEventHandlers.remove(eventHandler);
  }

  void subscribeOnRemoved(void Function(TileSetItem tileSetItem) eventHandler) {
    onRemovedEventHandlers.add(eventHandler);
  }

  void unsubscribeOnRemoved(void Function(TileSetItem tileSetItem) eventHandler) {
    onRemovedEventHandlers.remove(eventHandler);
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
}
