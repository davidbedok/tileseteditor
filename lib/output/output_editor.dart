import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/editor.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/output_action_controller.dart';
import 'package:tileseteditor/output/state/output_editor_state.dart';

class OutputEditor extends StatelessWidget {
  final TileSetProject project;
  final TileSet tileSet;
  final OutputEditorState outputState;
  final void Function() onSplitterPressed;

  const OutputEditor({
    super.key, //
    required this.project,
    required this.tileSet,
    required this.outputState,
    required this.onSplitterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutputActionController(
              project: project, //
              tileSet: tileSet,
              outputState: outputState,
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
                        project: project,
                        tileSet: tileSet,
                        width: MediaQuery.of(context).size.width - 100,
                        height: MediaQuery.of(context).size.height - TileSetEditor.topHeight,
                        outputState: outputState,
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
