import 'package:tileseteditor/domain/tilesetitem/tilegroup_file.dart';

class GroupState {
  List<TileGroupFile> selectedFiles = [];

  List<void Function(GroupState state, TileGroupFile groupFile)> selectionEventHandlers = [];

  GroupState();

  void subscribeSelection(void Function(GroupState state, TileGroupFile groupFile) eventHandler) {
    selectionEventHandlers.add(eventHandler);
  }

  void unsubscribeSelection(void Function(GroupState state, TileGroupFile groupFile) eventHandler) {
    selectionEventHandlers.remove(eventHandler);
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
}
