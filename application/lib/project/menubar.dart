import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/project_item.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/project/project_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectMenuBar extends StatelessWidget {
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
              onPressed: () {
                //
              },
              child: MenuAcceleratorLabel('&Documentation'),
            ),
            MenuItemButton(
              onPressed: () {
                //
              },
              child: MenuAcceleratorLabel('&Yate CLI'),
            ),
            Divider(),
            MenuItemButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AboutDialog(
                      applicationName: 'Yet Another TileSet Editor',
                      applicationVersion: '1.0.0',
                      applicationIcon: Image(image: AssetImage('assets/images/yate-512.png'), width: 70, height: 70),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
                          children: [
                            Text('Developer', style: Theme.of(context).textTheme.labelLarge), //
                            Text('Dávid Bedők (qwaevisz)'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
                          children: [
                            Text('Release date', style: Theme.of(context).textTheme.labelLarge), //
                            Text('2025.09.13'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
                          children: [
                            Text('Framework', style: Theme.of(context).textTheme.labelLarge), //
                            Text('Flutter'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
                          children: [
                            Text('Graphics', style: Theme.of(context).textTheme.labelLarge), //
                            InkWell(
                              child: Text('freepik', style: TextStyle(color: const Color.fromARGB(255, 24, 103, 168))),
                              onTap: () async {
                                if (!await launchUrl(Uri.parse('https://www.flaticon.com/authors/freepik'))) {
                                  throw Exception('Could not launch');
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
                          children: [
                            Text('Licence', style: Theme.of(context).textTheme.labelLarge), //
                            Text('GPL-3.0 license'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
                          children: [
                            Text('Source', style: Theme.of(context).textTheme.labelLarge), //
                            InkWell(
                              child: Text('github', style: TextStyle(color: const Color.fromARGB(255, 24, 103, 168))),
                              onTap: () async {
                                if (!await launchUrl(Uri.parse('https://github.com/davidbedok/tileseteditor'))) {
                                  throw Exception('Could not launch');
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.language_outlined), //
                            SizedBox(width: 10),
                            InkWell(
                              child: Text('https://yate.qwaevisz.com', style: TextStyle(color: const Color.fromARGB(255, 24, 103, 168))),
                              onTap: () async {
                                if (!await launchUrl(Uri.parse('https://yate.qwaevisz.com'))) {
                                  throw Exception('Could not launch');
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.email_outlined), //
                            SizedBox(width: 10),
                            Text('yate@qwaevisz.com'),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Image(image: AssetImage('assets/images/buy-me-a-coffee.png'), width: 25, height: 25),
                            SizedBox(width: 10),
                            InkWell(
                              child: Text('https://buymeacoffee.com/qwaevisz', style: TextStyle(color: const Color.fromARGB(255, 24, 103, 168))),
                              onTap: () async {
                                if (!await launchUrl(Uri.parse('https://buymeacoffee.com/qwaevisz'))) {
                                  throw Exception('Could not launch');
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    );
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
