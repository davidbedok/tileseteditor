import 'package:tileseteditor/domain/project_item.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class ProjectState {
  late ObjectLevelEvent<ProjectState, YateProject> project;
  late ObjectLevelEvent<ProjectState, YateProjectItem> item;

  ProjectState() {
    project = ObjectLevelEvent(state: this, noneObject: YateProject.none);
    item = ObjectLevelEvent(state: this, noneObject: YateProjectItem.none);
  }

  TileSet getItemAsTileSet() {
    return item.object is TileSet ? item.object as TileSet : TileSet.none;
  }

  TileGroup getItemAsTileGroup() {
    return item.object is TileGroup ? item.object as TileGroup : TileGroup.none;
  }
}
