import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/output/tileset/tileset_output_controller.dart';
import 'package:tileseteditor/project/selector.dart';
import 'package:tileseteditor/widgets/information_box.dart';

class TileSetOutputEditor extends StatelessWidget {
  static const double sideWidth = 250;
  final YateProject project;
  final TileSet tileSet;
  final OutputState outputState;
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
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - sideWidth - 30,
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
                            width: MediaQuery.of(context).size.width - sideWidth - 30,
                            height: MediaQuery.of(context).size.height - ProjectSelector.topHeight,
                            outputState: outputState,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: sideWidth,
                          height: MediaQuery.of(context).size.height - ProjectSelector.topHeight,
                          child: InformationBox(
                            texts: [
                              TextSpan(text: 'In '), //
                              TextSpan(
                                text: 'TileSet output editor',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ), //
                              TextSpan(
                                text:
                                    ' you can see the pre-defined areas of the current "${tileSet.name}" TileSet on the left side, meanwhile the entire output TileSet image is visible on the right side. This interface is primarily used to place elements from the "${tileSet.name}" tileset, but previously placed elements from other sources can also be edited.',
                              ), //
                              TextSpan(
                                text:
                                    '\n\nHere you can drag&drop any of the element with your mouse (however you cannot use your mouse for navigation, only for zooming).',
                              ),
                              TextSpan(text: '\n\nSelection:\n'), //
                              WidgetSpan(child: Icon(Icons.crop_square, color: EditorColor.selectedFill.color, size: 15)),
                              TextSpan(text: ' From "${tileSet.name}" TileSet\n'), //
                              WidgetSpan(child: Icon(Icons.crop_square, color: EditorColor.selectedExternalFill.color, size: 15)),
                              TextSpan(text: ' From other source\n'), //
                              TextSpan(
                                text:
                                    '\nTip: Using the WASD keys you can always move the image, even if one of the piece is selected. The arrow keys have multiple uses: you can move the selected element by one unit, or move the entire image if none of the elements are selected.',
                              ),
                            ],
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
