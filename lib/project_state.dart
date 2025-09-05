import 'package:tileseteditor/domain/tileset.dart';

class ProjectState {
  TileSet? selectedTileSet;

  List<void Function(ProjectState state, TileSet? tileSet)> onSelectedEventHandlers = [];

  ProjectState();

  void subscribeOnSelected(void Function(ProjectState state, TileSet? tileSet) eventHandler) {
    onSelectedEventHandlers.add(eventHandler);
  }

  void unsubscribeOnSelected(void Function(ProjectState state, TileSet? tileSet) eventHandler) {
    onSelectedEventHandlers.remove(eventHandler);
  }

  void select(TileSet? tileSet) {
    selectedTileSet = tileSet;
    for (var eventHandler in onSelectedEventHandlers) {
      eventHandler.call(this, tileSet);
    }
  }
}
