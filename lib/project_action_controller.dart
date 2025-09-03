import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';

class ProjectActionController extends StatefulWidget {
  final TileSetProject project;

  final void Function() onEditProject;
  final void Function() onCloseProject;
  final void Function() onAddTileSet;

  const ProjectActionController({
    super.key, //
    required this.project,
    required this.onEditProject,
    required this.onCloseProject,
    required this.onAddTileSet,
  });

  @override
  State<ProjectActionController> createState() => ProjectActionControllerState();
}

class ProjectActionControllerState extends State<ProjectActionController> {
  TileSetItem? selectedItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
