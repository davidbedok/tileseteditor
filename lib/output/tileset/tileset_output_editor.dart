import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/tileset/tileset_output_controller.dart';
import 'package:tileseteditor/output/tileset/tileset_output_state.dart';
import 'package:tileseteditor/project/selector.dart';

class TileSetOutputEditor extends StatelessWidget {
  final YateProject project;
  final TileSet tileSet;
  final TileSetOutputState outputState;
  final void Function() onSplitterPressed;

  const TileSetOutputEditor({
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
            TileSetOutputController(
              project: project, //
              tileSet: tileSet,
              outputState: outputState,
              onSplitterPressed: onSplitterPressed,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  height: MediaQuery.of(context).size.height - ProjectSelector.topHeight,
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: GameWidget(
                      game: OutputEditorGame(
                        project: project,
                        tileSet: tileSet,
                        tileGroup: TileGroup.none,
                        width: MediaQuery.of(context).size.width - 100,
                        height: MediaQuery.of(context).size.height - ProjectSelector.topHeight,
                        tileSetOutputState: outputState,
                        tileGroupOutputState: null,
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
