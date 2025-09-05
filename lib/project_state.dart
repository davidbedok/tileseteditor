import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/state/select_event.dart';

class ProjectState {
  late SelectEvent<ProjectState, TileSetProject> project;
  late SelectEvent<ProjectState, TileSet> tileSet;

  ProjectState() {
    project = SelectEvent(state: this);
    tileSet = SelectEvent(state: this);
  }
}
