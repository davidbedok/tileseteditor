import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/project_state.dart';

class ProjectController extends StatefulWidget {
  final TileSetProject project;
  final ProjectState projectState;

  final void Function() onEditProject;
  final void Function() onCloseProject;
  final void Function() onAddTileSet;
  final void Function() onEditTileSet;

  const ProjectController({
    super.key, //
    required this.project,
    required this.projectState,
    required this.onEditProject,
    required this.onCloseProject,
    required this.onAddTileSet,
    required this.onEditTileSet,
  });

  @override
  State<ProjectController> createState() => ProjectControllerState();
}

class ProjectControllerState extends State<ProjectController> {
  TileSet? selectedTileSet;

  @override
  void initState() {
    super.initState();
    widget.projectState.tileSet.subscribe(selectTileSet);
  }

  @override
  void dispose() {
    super.dispose();
    widget.projectState.tileSet.unsubscribe(selectTileSet);
  }

  void selectTileSet(ProjectState state, TileSet? tileSet) {
    setState(() {
      selectedTileSet = tileSet;
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
            label: Text('Edit ${widget.project.name} project'),
            onPressed: () {
              widget.onEditProject.call();
            },
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.add), //
            label: Text('Add TileSet'),
            onPressed: () {
              widget.onAddTileSet.call();
            },
          ),
          SizedBox(width: 5),
          Visibility(
            visible: selectedTileSet != null,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add), //
              label: Text('Edit ${selectedTileSet != null ? selectedTileSet!.name : ''} TileSet'),
              onPressed: () {
                widget.onEditTileSet.call();
              },
            ),
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.close), //
            label: Text('Close ${widget.project.name} project'),
            onPressed: () {
              widget.onCloseProject.call();
            },
          ),
        ],
      ),
    );
  }
}
