import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/editor.dart';
import 'package:tileseteditor/overview/flame/overview_editor_game.dart';
import 'package:tileseteditor/overview/overview_action_controller.dart';
import 'package:tileseteditor/overview/overview_editor_state.dart';

class OverviewEditor extends StatelessWidget {
  final TileSetProject project;
  final OverviewEditorState overviewState;

  const OverviewEditor({
    super.key, //
    required this.project,
    required this.overviewState,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OverviewActionController(
              project: project, //
              overviewState: overviewState,
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
                      game: OverviewEditorGame(
                        project: project,
                        width: MediaQuery.of(context).size.width - 100,
                        height: MediaQuery.of(context).size.height - TileSetEditor.topHeight,
                        overviewState: overviewState,
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
