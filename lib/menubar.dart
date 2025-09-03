import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_project.dart';

class TileSetEditorMenuBar extends StatelessWidget {
  final TileSetProject? project;
  final void Function() onNewProject;
  final void Function() onOpenProject;
  final void Function() onSaveProject;
  final void Function() onSaveAsProject;
  final void Function() onEditProject;
  final void Function() onCloseProject;
  final void Function() onAddTileSet;

  const TileSetEditorMenuBar({
    super.key,
    required this.project,
    required this.onNewProject,
    required this.onOpenProject,
    required this.onSaveProject,
    required this.onSaveAsProject,
    required this.onEditProject,
    required this.onCloseProject,
    required this.onAddTileSet,
  });

  @override
  Widget build(BuildContext context) {
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
            /*
            MenuItemButton(
              child: SubmenuButton(
                menuChildren: <Widget>[
                  MenuItemButton(
                    onPressed: () {
                      onNewProject.call();
                    },
                    child: const MenuAcceleratorLabel('&Project'),
                  ),
                ],
                child: const MenuAcceleratorLabel('&New'),
              ),
            ),
            */
            MenuItemButton(
              onPressed: onNewProject,
              // style: MenuItemButton.styleFrom(textStyle: Theme.of(context).textTheme.bodySmall),
              child: const MenuAcceleratorLabel('&New project'),
            ),
            MenuItemButton(onPressed: onOpenProject, child: const MenuAcceleratorLabel('&Open project')),
            Divider(),
            MenuItemButton(onPressed: project == null ? null : onSaveProject, child: const MenuAcceleratorLabel('&Save project')),
            MenuItemButton(onPressed: project == null ? null : onSaveAsProject, child: const MenuAcceleratorLabel('Save as..')),
            Divider(),
            MenuItemButton(onPressed: project == null ? null : onCloseProject, child: const MenuAcceleratorLabel('&Close project')),
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
            MenuItemButton(onPressed: project == null ? null : onEditProject, child: const MenuAcceleratorLabel('&Edit project')),
            Divider(),
            MenuItemButton(onPressed: project != null && project!.filePath != null ? onAddTileSet : null, child: const MenuAcceleratorLabel('&Add tileset')),
          ],
          child: const MenuAcceleratorLabel('&Edit'),
        ),
        SubmenuButton(
          style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.only(left: 5, right: 5))),
          menuChildren: <Widget>[
            MenuItemButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Magnify!')));
              },
              child: const MenuAcceleratorLabel('&Credit'),
            ),
          ],
          child: const MenuAcceleratorLabel('&About'),
        ),
      ],
    );
  }
}
