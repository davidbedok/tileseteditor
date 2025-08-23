import 'dart:ui' as dui;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/current.dart';
import 'package:tileseteditor/dialogs/add_group_dialog.dart';
import 'package:tileseteditor/dialogs/add_slice_dialog.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_group.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/flame/editor_game.dart';
import 'package:tileseteditor/state/editor_state.dart';

class TileSetEditor extends StatelessWidget {
  final TileSetProject project;
  final TileSet tileSet;
  final dui.Image tileSetImage;
  final EditorState editorState;

  const TileSetEditor({super.key, required this.project, required this.tileSet, required this.tileSetImage, required this.editorState});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.add_circle_outline),
                    label: const Text('Slice'),
                    onPressed: () {
                      if (editorState.selectedFreeTiles.isNotEmpty) {
                        addSlice(context, editorState);
                      }
                    },
                  ),
                  SizedBox(width: 5),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add_circle_outline),
                    label: const Text('Group'),
                    onPressed: () {
                      if (editorState.selectedFreeTiles.isNotEmpty) {
                        addGroup(context, editorState);
                      }
                    },
                  ),
                  SizedBox(width: 5),
                  ElevatedButton.icon(
                    icon: Icon(Icons.cancel),
                    label: const Text('Drop'),
                    onPressed: () {
                      if (editorState.selectedFreeTiles.isNotEmpty) {
                        tileSet.addGarbage(editorState.selectedFreeTiles);
                        editorState.selectedFreeTiles.clear();
                      }
                    },
                  ),
                  SizedBox(width: 5),
                  ElevatedButton.icon(
                    icon: Icon(Icons.cancel_outlined),
                    label: const Text('Undrop'),
                    onPressed: () {
                      if (editorState.selectedGarbageTiles.isNotEmpty) {
                        tileSet.removeGarbage(editorState.selectedGarbageTiles);
                        editorState.selectedGarbageTiles.clear();
                      }
                    },
                  ),
                  SizedBox(width: 5),
                  ElevatedButton.icon(
                    icon: Icon(Icons.delete),
                    label: const Text('Delete'),
                    onPressed: () {
                      if (editorState.selectedTileInfo != null) {
                        tileSet!.remove(editorState.selectedTileInfo!);
                        editorState.selectedTileInfo = null;
                      }
                    },
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 400,
                      height: MediaQuery.of(context).size.height - 200,
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                        child: GameWidget(
                          game: EditorGame(
                            tileSet: tileSet,
                            width: 400,
                            height: MediaQuery.of(context).size.height - 200,
                            tileSetImage: tileSetImage,
                            editorState: editorState,
                          ),
                        ),
                      ),
                    ), //
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 500,
                          height: MediaQuery.of(context).size.height - 200,
                          child: Container(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                            child: ListView(
                              children: [
                                Row(
                                  children: [
                                    Text('Image size:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text('${tileSet.imageWidth} x ${tileSet.imageHeight}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Tile size:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text('${tileSet.tileWidth} x ${tileSet.tileHeight}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Max tile:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text('${tileSet.getMaxTileColumn()} x ${tileSet.getMaxTileRow()}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Number of slices:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text('${tileSet.slices.length}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Number of groups:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text('${tileSet.groups.length}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Number of garbages:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text('${tileSet.garbage.indices.length}'),
                                  ],
                                ),
                                CurrentSelection(editorState: editorState),
                              ],
                            ),
                          ),
                        ), //
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void addSlice(BuildContext context, EditorState editorState) async {
    TileSetSlice? dialogResult = await showDialog<TileSetSlice>(
      context: context,
      builder: (BuildContext context) {
        return AddSliceDialog(tileSet: tileSet, tiles: editorState.selectedFreeTiles);
      },
    );
    if (dialogResult != null) {
      tileSet.addSlice(dialogResult);
      editorState.selectedFreeTiles.clear();
    }
  }

  void addGroup(BuildContext context, EditorState editorState) async {
    TileSetGroup? dialogResult = await showDialog<TileSetGroup>(
      context: context,
      builder: (BuildContext context) {
        return AddGroupDialog(tileSet: tileSet, tiles: editorState.selectedFreeTiles);
      },
    );
    if (dialogResult != null) {
      tileSet.addGroup(dialogResult);
      editorState.selectedFreeTiles.clear();
    }
  }
}
