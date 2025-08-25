import 'dart:ui' as dui;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/editor_datasheet.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/editor_action_controller.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditorActionController(editorState: editorState, tileSet: tileSet),
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
                            child: EditorDatasheet(editorState: editorState, tileSet: tileSet),
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
}
