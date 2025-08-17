import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tileseteditor/domain/tileset_project.dart';

class TileSetEditorMenuBar extends StatelessWidget {
  final TileSetProject? project;
  final void Function() onNewProject;

  const TileSetEditorMenuBar({super.key, required this.project, required this.onNewProject});

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      children: <Widget>[
        SubmenuButton(
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
              onPressed: () {
                onNewProject.call();
              },
              child: const MenuAcceleratorLabel('&New project'),
            ),
            MenuItemButton(
              onPressed: () {
                print('Open project');
              },
              child: const MenuAcceleratorLabel('&Open project'),
            ),
            Divider(),
            MenuItemButton(
              onPressed: project == null
                  ? null
                  : () {
                      print('Save project');
                    },
              child: const MenuAcceleratorLabel('&Save project..'),
            ),
            Divider(),
            MenuItemButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quit!')));
              },
              child: const MenuAcceleratorLabel('&Exit'),
            ),
          ],
          child: const MenuAcceleratorLabel('&File'),
        ),
        SubmenuButton(
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
