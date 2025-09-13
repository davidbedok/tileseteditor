import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/tilegroup/tilegroup_output_controller.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/project/selector.dart';

class TileGroupOutputEditor extends StatelessWidget {
  final YateProject project;
  final TileGroup tileGroup;
  final OutputState outputState;
  final void Function() onBuilderPressed;

  const TileGroupOutputEditor({
    super.key, //
    required this.project,
    required this.tileGroup,
    required this.outputState,
    required this.onBuilderPressed,
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
              onBuilderPressed: onBuilderPressed,
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
