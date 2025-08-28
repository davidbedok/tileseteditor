import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/editor.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/output_action_controller.dart';

class OutputEditor extends StatelessWidget {
  final void Function() onSplitterPressed;

  const OutputEditor({
    super.key, //
    required this.widget,
    required this.onSplitterPressed,
  });

  final TileSetEditor widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutputActionController(
              project: widget.project, //
              tileSet: widget.tileSet,
              onSplitterPressed: onSplitterPressed,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  height: MediaQuery.of(context).size.height - TileSetEditor.topHeight,
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: GameWidget(
                      game: OutputEditorGame(
                        tileSet: widget.tileSet,
                        width: MediaQuery.of(context).size.width - 100,
                        height: MediaQuery.of(context).size.height - TileSetEditor.topHeight,
                        tileSetImage: widget.tileSetImage,
                        editorState: widget.editorState,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
