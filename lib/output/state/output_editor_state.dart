import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';

class OutputEditorState {
  TileSetItem? selectedItem;

  List<void Function(OutputEditorState state, TileSetItem tileSetItem)> onSelectedEventHandlers = [];

  OutputEditorState();

  void subscribeOnSelected(void Function(OutputEditorState state, TileSetItem tileSetItem) eventHandler) {
    onSelectedEventHandlers.add(eventHandler);
  }

  void unsubscribeOnSelected(void Function(OutputEditorState state, TileSetItem tileSetItem) eventHandler) {
    onSelectedEventHandlers.remove(eventHandler);
  }
}
