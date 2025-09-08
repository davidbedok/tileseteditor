import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class ProjectState {
  late ObjectLevelEvent<ProjectState, TileSetProject> project;
  late ObjectLevelEvent<ProjectState, TileSet> tileSet;
  late ObjectLevelEvent<ProjectState, TileGroup> tileGroup;

  ProjectState() {
    project = ObjectLevelEvent(state: this, noneObject: TileSetProject.none);
    tileSet = ObjectLevelEvent(state: this, noneObject: TileSet.none);
    tileGroup = ObjectLevelEvent(state: this, noneObject: TileGroup.none);
  }
}
