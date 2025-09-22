import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/project_item.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/project/project_state.dart';

class ProjectController extends StatefulWidget {
  final ProjectState projectState;

  final void Function() onEditProject;
  final void Function() onCloseProject;
  final void Function() onAddTileSet;
  final void Function() onAddTileGroup;
  final void Function() onEditTileSet;
  final void Function() onDeleteTileSet;
  final void Function() onEditTileGroup;
  final void Function() onDeleteTileGroup;

  const ProjectController({
    super.key, //
    required this.projectState,
    required this.onEditProject,
    required this.onCloseProject,
    required this.onAddTileSet,
    required this.onAddTileGroup,
    required this.onEditTileSet,
    required this.onDeleteTileSet,
    required this.onEditTileGroup,
    required this.onDeleteTileGroup,
  });

  @override
  State<ProjectController> createState() => ProjectControllerState();
}

class ProjectControllerState extends State<ProjectController> {
  late YateProject project;
  late YateProjectItem item;

  @override
  void initState() {
    super.initState();
    project = widget.projectState.project.object;
    item = widget.projectState.item.object;
    widget.projectState.project.subscribeSelection(selectProject);
    widget.projectState.item.subscribeSelection(selectItem);
  }

  @override
  void dispose() {
    super.dispose();
    widget.projectState.project.unsubscribeSelection(selectProject);
    widget.projectState.item.unsubscribeSelection(selectItem);
  }

  void selectProject(ProjectState state, YateProject project) {
    setState(() {
      this.project = project;
    });
  }

  void selectItem(ProjectState state, YateProjectItem prjectItem) {
    setState(() {
      item = prjectItem;
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
          Visibility(
            visible: project.filePath != null && item == YateProjectItem.none,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add), //
              label: Text('Add TileSet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(117, 110, 190, 84),
                foregroundColor: const Color.fromARGB(255, 229, 224, 224),
              ),
              onPressed: () {
                widget.onAddTileSet.call();
              },
            ),
          ),
          SizedBox(width: 5),
          Visibility(
            visible: project.filePath != null && item == YateProjectItem.none,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add), //
              label: Text('Add TileGroup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(117, 110, 190, 84),
                foregroundColor: const Color.fromARGB(255, 229, 224, 224),
              ),
              onPressed: () {
                widget.onAddTileGroup.call();
              },
            ),
          ),
          SizedBox(width: 5),
          Visibility(
            visible: item.isTileSet(),
            child: ElevatedButton.icon(
              icon: Icon(Icons.edit), //
              label: Text('${item.name} tileset'),
              onPressed: () {
                widget.onEditTileSet.call();
              },
            ),
          ),
          Visibility(
            visible: item.isTileGroup(),
            child: ElevatedButton.icon(
              icon: Icon(Icons.edit), //
              label: Text('${item.name} tilegroup'),
              onPressed: () {
                widget.onEditTileGroup.call();
              },
            ),
          ),
          SizedBox(width: 5),
          Visibility(
            visible: item.isTileSet(),
            child: ElevatedButton.icon(
              icon: Icon(Icons.delete), //
              label: Text('${item.name} tileset'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(82, 206, 46, 6), foregroundColor: const Color.fromARGB(255, 229, 224, 224)),
              onPressed: () {
                widget.onDeleteTileSet.call();
              },
            ),
          ),
          Visibility(
            visible: item.isTileGroup(),
            child: ElevatedButton.icon(
              icon: Icon(Icons.delete), //
              label: Text('${item.name} tilegroup'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(82, 206, 46, 6), foregroundColor: const Color.fromARGB(255, 229, 224, 224)),
              onPressed: () {
                widget.onDeleteTileGroup.call();
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
