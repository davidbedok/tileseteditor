import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/event/object_level_event.dart';

class ProjectState {
  late ObjectLevelEvent<ProjectState, TileSetProject> project;
  late ObjectLevelEvent<ProjectState, TileSet> tileSet;

  ProjectState() {
    project = ObjectLevelEvent(state: this, noneObject: TileSetProject.none);
    tileSet = ObjectLevelEvent(state: this, noneObject: TileSet.none);
  }
}
