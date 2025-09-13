import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/output/tilegroup/flame/tilegroup_output_editor_game.dart';
import 'package:tileseteditor/output/tilegroup/tilegroup_output_controller.dart';
import 'package:tileseteditor/output/tilegroup/tilegroup_output_state.dart';
import 'package:tileseteditor/project/selector.dart';

class TileGroupOutputEditor extends StatelessWidget {
  final TileSetProject project;
  final TileGroup tileGroup;
  final TileGroupOutputState outputState;
  final void Function() onSplitterPressed;

  const TileGroupOutputEditor({
    super.key, //
    required this.project,
    required this.tileGroup,
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
            TileGroupOutputController(
              project: project, //
              tileGroup: tileGroup,
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
                      game: TileGroupOutputEditorGame(
                        project: project,
                        tileSet: TileSet.none,
                        tileGroup: tileGroup,
                        width: MediaQuery.of(context).size.width - 100,
                        height: MediaQuery.of(context).size.height - ProjectSelector.topHeight,
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
