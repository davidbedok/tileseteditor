import 'dart:ui' as dui;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/dialogs/add_group_dialog.dart';
import 'package:tileseteditor/dialogs/add_slice_dialog.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_group.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/flame/editor_game.dart';
import 'package:tileseteditor/state/editor_state.dart';

class TileSetEditor extends StatefulWidget {
  final TileSetProject project;
  final TileSet tileSet;
  final dui.Image tileSetImage;
  final EditorState editorState;

  const TileSetEditor({super.key, required this.project, required this.tileSet, required this.tileSetImage, required this.editorState});

  @override
  State<TileSetEditor> createState() => TileSetEditorState();
}

class TileSetEditorState extends State<TileSetEditor> {
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
    return Row(
      children: [
        Column(
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.add_circle_outline),
                  label: const Text('Slice'),
                  onPressed: widget.editorState.selectedTileInfo != null
                      ? null
                      : () {
                          if (widget.editorState.selectedFreeTiles.isNotEmpty) {
                            addSlice(widget.editorState);
                          }
                        },
                ),
                SizedBox(width: 5),
                ElevatedButton.icon(
                  icon: Icon(Icons.add_circle_outline),
                  label: const Text('Group'),
                  onPressed: widget.editorState.selectedTileInfo != null
                      ? null
                      : () {
                          if (widget.editorState.selectedFreeTiles.isNotEmpty) {
                            addGroup(widget.editorState);
                          }
                        },
                ),
                SizedBox(width: 5),
                ElevatedButton.icon(
                  icon: Icon(Icons.cancel),
                  label: const Text('Drop'),
                  onPressed: widget.editorState.selectedTileInfo != null
                      ? null
                      : () {
                          if (widget.editorState.selectedFreeTiles.isNotEmpty) {
                            widget.tileSet.addGarbage(widget.editorState.selectedFreeTiles);
                            widget.editorState.selectedFreeTiles.clear();
                          }
                        },
                ),
                SizedBox(width: 5),
                ElevatedButton.icon(
                  icon: Icon(Icons.cancel_outlined),
                  label: const Text('Undrop'),
                  onPressed: widget.editorState.selectedTileInfo != null
                      ? null
                      : () {
                          if (widget.editorState.selectedGarbageTiles.isNotEmpty) {
                            widget.tileSet.removeGarbage(widget.editorState.selectedGarbageTiles);
                            widget.editorState.selectedGarbageTiles.clear();
                          }
                        },
                ),
                SizedBox(width: 5),
                ElevatedButton.icon(
                  icon: Icon(Icons.delete),
                  label: const Text('Delete'),
                  onPressed: widget.editorState.selectedTileInfo == null
                      ? null
                      : () {
                          widget.tileSet!.remove(widget.editorState.selectedTileInfo!);
                          widget.editorState.selectedTileInfo = null;
                        },
                ),
              ],
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
                            tileSet: widget.tileSet,
                            width: 400,
                            height: MediaQuery.of(context).size.height - 200,
                            tileSetImage: widget.tileSetImage,
                            editorState: widget.editorState,
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
                                    Text('${widget.tileSet.imageWidth} x ${widget.tileSet.imageHeight}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Tile size:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text('${widget.tileSet.tileWidth} x ${widget.tileSet.tileHeight}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Max tile:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text('${widget.tileSet.getMaxTileColumn()} x ${widget.tileSet.getMaxTileRow()}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Number of slices:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text('${widget.tileSet.slices.length}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Number of groups:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text('${widget.tileSet.groups.length}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Number of garbages:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text('${widget.tileSet.garbage.indices.length}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Selected:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text(
                                      widget.editorState.selectedTileInfo != null
                                          ? '${widget.editorState.selectedTileInfo!.name} (${widget.editorState.selectedTileInfo!.type.name})'
                                          : '-',
                                    ),
                                  ],
                                ),
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

  void addSlice(EditorState editorState) async {
    TileSetSlice? dialogResult = await showDialog<TileSetSlice>(
      context: context,
      builder: (BuildContext context) {
        return AddSliceDialog(tileSet: widget.tileSet, tiles: editorState.selectedFreeTiles);
      },
    );
    if (dialogResult != null) {
      widget.tileSet.addSlice(dialogResult);
      editorState.selectedFreeTiles.clear();
    }
  }

  void addGroup(EditorState editorState) async {
    TileSetGroup? dialogResult = await showDialog<TileSetGroup>(
      context: context,
      builder: (BuildContext context) {
        return AddGroupDialog(tileSet: widget.tileSet, tiles: editorState.selectedFreeTiles);
      },
    );
    if (dialogResult != null) {
      widget.tileSet.addGroup(dialogResult);
      editorState.selectedFreeTiles.clear();
    }
  }
}
