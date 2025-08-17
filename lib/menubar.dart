import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tileseteditor/dialogs/new_project_dialog.dart';
import 'package:tileseteditor/domain/tileset_project.dart';

class TileSetEditorMenuBar extends StatelessWidget {
  const TileSetEditorMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: MenuBar(
                children: <Widget>[
                  SubmenuButton(
                    menuChildren: <Widget>[
                      MenuItemButton(
                        child: SubmenuButton(
                          menuChildren: <Widget>[
                            MenuItemButton(
                              shortcut: const SingleActivator(LogicalKeyboardKey.keyP, control: true),
                              onPressed: () async {
                                TileSetProject? dialogResult = await showDialog<TileSetProject>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return NewProjectDialog();
                                  },
                                );
                                if (dialogResult != null) {
                                  print(dialogResult);
                                }
                              },
                              child: const MenuAcceleratorLabel('&Project'),
                            ),
                          ],
                          child: const MenuAcceleratorLabel('&New'),
                        ),
                      ),
                      Divider(),
                      MenuItemButton(
                        onPressed: () {
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
              ),
            ),
          ],
        ),
        Expanded(child: FlutterLogo(size: MediaQuery.of(context).size.shortestSide * 0.5)),
      ],
    );
  }
}
