import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/items/tilegroup_file.dart';

class GroupState {
  List<TileGroupFile> selectedFiles = [];

  List<void Function(GroupState state, TileGroupFile groupFile)> selectionEventHandlers = [];

  List<void Function(GroupState state, bool select)> selectionAllEventHandlers = [];

  GroupState();

  void subscribeSelection(void Function(GroupState state, TileGroupFile groupFile) eventHandler) {
    selectionEventHandlers.add(eventHandler);
  }

  void unsubscribeSelection(void Function(GroupState state, TileGroupFile groupFile) eventHandler) {
    selectionEventHandlers.remove(eventHandler);
  }

  void subscribeSelectioAll(void Function(GroupState state, bool select) eventHandler) {
    selectionAllEventHandlers.add(eventHandler);
  }

  void unsubscribeSelectionAll(void Function(GroupState state, bool select) eventHandler) {
    selectionAllEventHandlers.remove(eventHandler);
  }

  void selectTileGroupFile(TileGroupFile groupFile) {
    if (isSelected(groupFile)) {
      selectedFiles.remove(groupFile);
    } else {
      selectedFiles.add(groupFile);
    }
    for (var eventHandler in selectionEventHandlers) {
      eventHandler.call(this, groupFile);
    }
  }

  bool isSelected(TileGroupFile groupFile) {
    return selectedFiles.where((file) => file.id == groupFile.id).isNotEmpty;
  }

  void selectAll(TileGroup tileGroup) {
    selectedFiles.clear();
    selectedFiles.addAll(tileGroup.files);
    for (var eventHandler in selectionAllEventHandlers) {
      eventHandler.call(this, true);
    }
  }

  void deselectAll() {
    selectedFiles.clear();
    for (var eventHandler in selectionAllEventHandlers) {
      eventHandler.call(this, false);
    }
  }
}
