import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/dialogs/documentation_dialog.dart';
import 'package:tileseteditor/domain/project_item.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/widgets/about_widget.dart';
import 'package:tileseteditor/project/project_state.dart';

class ProjectMenuBar extends StatelessWidget {
  final PackageInfo packageInfo;
  final ProjectState projectState;
  final void Function() onNewProject;
  final void Function() onOpenProject;
  final void Function() onSaveProject;
  final void Function() onSaveAsProject;
  final void Function() onCloseProject;

  final void Function() onEditProject;
  final void Function() onAddTileSet;
  final void Function() onEditTileSet;
  final void Function() onDeleteTileSet;
  final void Function() onAddTileGroup;
  final void Function() onEditTileGroup;
  final void Function() onDeleteTileGroup;

  const ProjectMenuBar({
    super.key,
    required this.packageInfo,
    required this.projectState,
    required this.onNewProject,
    required this.onOpenProject,
    required this.onSaveProject,
    required this.onSaveAsProject,
    required this.onCloseProject,
    required this.onEditProject,
    required this.onAddTileSet,
    required this.onEditTileSet,
    required this.onDeleteTileSet,
    required this.onAddTileGroup,
    required this.onEditTileGroup,
    required this.onDeleteTileGroup,
  });

  @override
  Widget build(BuildContext context) {
    YateProject project = projectState.project.object;
    YateProjectItem item = projectState.item.object;

    return MenuBar(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.amber),
        // padding: WidgetStatePropertyAll(EdgeInsets.only(left: 10)),
        maximumSize: WidgetStatePropertyAll(Size(100, 30)),
      ),
      children: <Widget>[
        SubmenuButton(
          style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.only(left: 5, right: 5))),
          menuChildren: <Widget>[
            MenuItemButton(onPressed: projectState.project.isDefined() ? null : onNewProject, child: const MenuAcceleratorLabel('&New project')),
            MenuItemButton(onPressed: projectState.project.isDefined() ? null : onOpenProject, child: const MenuAcceleratorLabel('&Open project')),
            Divider(),
            MenuItemButton(
              onPressed: projectState.project.isNotDefined() ? null : onSaveProject,
              child: MenuAcceleratorLabel('&Save  project${projectState.project.isDefined() ? ' (${project.name})' : ''}'),
            ),
            MenuItemButton(
              onPressed: projectState.project.isNotDefined() ? null : onSaveAsProject,
              child: MenuAcceleratorLabel('Save as..${projectState.project.isDefined() ? ' (${project.name})' : ''}'),
            ),
            Divider(),
            MenuItemButton(
              onPressed: projectState.project.isNotDefined() ? null : onCloseProject,
              child: MenuAcceleratorLabel('&Close project${projectState.project.isDefined() ? ' (${project.name})' : ''}'),
            ),
            Divider(),
            MenuItemButton(
              onPressed: () {
                exit(0);
              },
              child: const MenuAcceleratorLabel('&Exit'),
            ),
          ],
          child: const MenuAcceleratorLabel('&File'),
        ),
        SubmenuButton(
          style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.only(left: 5, right: 5))),
          menuChildren: <Widget>[
            MenuItemButton(
              onPressed: projectState.project.isNotDefined() ? null : onEditProject, //
              child: MenuAcceleratorLabel('&Edit project${projectState.project.isDefined() ? ' (${project.name})' : ''}'),
            ),
            Divider(),
            MenuItemButton(
              child: SubmenuButton(
                menuChildren: <Widget>[
                  MenuItemButton(
                    onPressed: projectState.project.isDefined() && project.filePath != null ? onAddTileSet : null,
                    child: MenuAcceleratorLabel('&Add new tileset${projectState.project.isDefined() ? ' (to ${project.name})' : ''}'),
                  ),
                  MenuItemButton(
                    onPressed: projectState.item.object.isTileSet() ? onEditTileSet : null,
                    child: MenuAcceleratorLabel('&Edit tileset${projectState.item.object.isTileSet() ? ' (${item.name})' : ''}'),
                  ),
                  MenuItemButton(
                    onPressed: projectState.item.object.isTileSet() ? onDeleteTileSet : null,
                    child: MenuAcceleratorLabel('&Delete tileset${projectState.item.object.isTileSet() ? ' (${item.name})' : ''}'),
                  ),
                ],
                child: const MenuAcceleratorLabel('Tile&Set'),
              ),
            ),
            MenuItemButton(
              child: SubmenuButton(
                menuChildren: <Widget>[
                  MenuItemButton(
                    onPressed: projectState.project.isDefined() && project.filePath != null ? onAddTileGroup : null,
                    child: MenuAcceleratorLabel('&Add new tilegroup${projectState.project.isDefined() ? ' (to ${project.name})' : ''}'),
                  ),
                  MenuItemButton(
                    onPressed: projectState.item.object.isTileGroup() ? onEditTileGroup : null,
                    child: MenuAcceleratorLabel('&Edit tilegroup${projectState.item.object.isTileGroup() ? ' (${item.name})' : ''}'),
                  ),
                  MenuItemButton(
                    onPressed: projectState.item.object.isTileGroup() ? onDeleteTileGroup : null,
                    child: MenuAcceleratorLabel('&Delete tilegroup${projectState.item.object.isTileGroup() ? ' (${item.name})' : ''}'),
                  ),
                ],
                child: const MenuAcceleratorLabel('Tile&Group'),
              ),
            ),
          ],
          child: const MenuAcceleratorLabel('&Edit'),
        ),
        SubmenuButton(
          style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.only(left: 5, right: 5))),
          menuChildren: <Widget>[
            MenuItemButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DocumentationDialog();
                  },
                );
              },
              child: MenuAcceleratorLabel('&User guide'),
            ),
            Divider(),
            MenuItemButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AboutWidget(packageInfo: packageInfo);
                  },
                );
              },
              child: const MenuAcceleratorLabel('&About'),
            ),
          ],
          child: const MenuAcceleratorLabel('&Help'),
        ),
      ],
    );
  }
}
