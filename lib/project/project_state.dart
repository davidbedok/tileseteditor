import 'package:tileseteditor/domain/project_item.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class ProjectState {
  late ObjectLevelEvent<ProjectState, TileSetProject> project;
  late ObjectLevelEvent<ProjectState, TileSetProjectItem> item;

  ProjectState() {
    project = ObjectLevelEvent(state: this, noneObject: TileSetProject.none);
    item = ObjectLevelEvent(state: this, noneObject: TileSetProjectItem.none);
  }

  TileSet getItemAsTileSet() {
    return item.object is TileSet ? item.object as TileSet : TileSet.none;
  }

  TileGroup getItemAsTileGroup() {
    return item.object is TileGroup ? item.object as TileGroup : TileGroup.none;
  }
}
