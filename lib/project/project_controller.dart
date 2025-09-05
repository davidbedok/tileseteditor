import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/project/project_state.dart';

class ProjectController extends StatefulWidget {
  final ProjectState projectState;

  final void Function() onEditProject;
  final void Function() onCloseProject;
  final void Function() onAddTileSet;
  final void Function() onEditTileSet;
  final void Function() onDeleteTileSet;

  const ProjectController({
    super.key, //
    required this.projectState,
    required this.onEditProject,
    required this.onCloseProject,
    required this.onAddTileSet,
    required this.onEditTileSet,
    required this.onDeleteTileSet,
  });

  @override
  State<ProjectController> createState() => ProjectControllerState();
}

class ProjectControllerState extends State<ProjectController> {
  late TileSetProject project;
  late TileSet tileSet;

  @override
  void initState() {
    super.initState();
    project = widget.projectState.project.object;
    tileSet = widget.projectState.tileSet.object;
    widget.projectState.project.subscribe(selectProject);
    widget.projectState.tileSet.subscribe(selectTileSet);
  }

  @override
  void dispose() {
    super.dispose();
    widget.projectState.project.unsubscribe(selectProject);
    widget.projectState.tileSet.unsubscribe(selectTileSet);
  }

  void selectProject(ProjectState state, TileSetProject project) {
    setState(() {
      this.project = project;
    });
  }

  void selectTileSet(ProjectState state, TileSet tileSet) {
    setState(() {
      this.tileSet = tileSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.edit),
            label: Text('${project.name} project'),
            onPressed: () {
              widget.onEditProject.call();
            },
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.add), //
            label: Text('Add tileset'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(117, 110, 190, 84),
              foregroundColor: const Color.fromARGB(255, 229, 224, 224),
            ),
            onPressed: () {
              widget.onAddTileSet.call();
            },
          ),
          SizedBox(width: 5),
          Visibility(
            visible: tileSet != TileSet.none,
            child: ElevatedButton.icon(
              icon: Icon(Icons.edit), //
              label: Text('${tileSet.name} tileset'),
              onPressed: () {
                widget.onEditTileSet.call();
              },
            ),
          ),
          SizedBox(width: 5),
          Visibility(
            visible: tileSet != TileSet.none,
            child: ElevatedButton.icon(
              icon: Icon(Icons.delete), //
              label: Text('${tileSet.name} tileset'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(82, 206, 46, 6), foregroundColor: const Color.fromARGB(255, 229, 224, 224)),
              onPressed: () {
                widget.onDeleteTileSet.call();
              },
            ),
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.close), //
            label: Text('Close project'),
            onPressed: () {
              widget.onCloseProject.call();
            },
          ),
        ],
      ),
    );
  }
}
