import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/editor.dart';
import 'package:tileseteditor/splitter/editor_action_controller.dart';
import 'package:tileseteditor/splitter/editor_datasheet.dart';
import 'package:tileseteditor/splitter/flame/editor_game.dart';

class SplitterEditor extends StatelessWidget {
  final void Function() onOutputPressed;

  const SplitterEditor({
    super.key, //
    required this.widget,
    required this.onOutputPressed,
  });

  final TileSetEditor widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditorActionController(
              project: widget.project, //
              editorState: widget.editorState,
              tileSet: widget.tileSet,
              onOutputPressed: onOutputPressed,
            ),
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 400,
                      height: MediaQuery.of(context).size.height - TileSetEditor.topHeight,
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                        child: GameWidget(
                          game: EditorGame(
                            tileSet: widget.tileSet,
                            width: MediaQuery.of(context).size.width - 400,
                            height: MediaQuery.of(context).size.height - TileSetEditor.topHeight,
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
                          width: 300,
                          height: MediaQuery.of(context).size.height - TileSetEditor.topHeight,
                          child: Container(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                            child: EditorDatasheet(editorState: widget.editorState, tileSet: widget.tileSet),
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
