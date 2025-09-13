import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/overview/flame/overview_editor_game.dart';
import 'package:tileseteditor/overview/overview_controller.dart';
import 'package:tileseteditor/project/selector.dart';

class OverviewEditor extends StatelessWidget {
  final YateProject project;
  final OutputState outputState;

  const OverviewEditor({
    super.key, //
    required this.project,
    required this.outputState,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OverviewController(
              project: project, //
              outputState: outputState,
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
                      game: OverviewEditorGame(
                        project: project,
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
