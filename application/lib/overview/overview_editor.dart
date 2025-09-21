import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/overview/flame/overview_editor_game.dart';
import 'package:tileseteditor/overview/overview_controller.dart';
import 'package:tileseteditor/project/selector.dart';
import 'package:tileseteditor/widgets/information_box.dart';

class OverviewEditor extends StatelessWidget {
  static const double sideWidth = 250;

  final YateProject project;
  final OutputState outputState;
  final void Function() onGeneratePressed;

  const OverviewEditor({
    super.key, //
    required this.project,
    required this.outputState,
    required this.onGeneratePressed,
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
              onGeneratePressed: onGeneratePressed,
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
                          game: OverviewEditorGame(
                            project: project,
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
                                text: 'Overview output editor',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ), //
                              TextSpan(
                                text:
                                    ' the final TileSet appears as the generated image will look like. You can move the image by dragging the mouse or using the arrow keys, if nothing is selected. Also use your mouse wheel to zoom in or out.',
                              ), //
                              TextSpan(
                                text:
                                    '\nElements can be selected by clicking with any mouse button and their position can be fine-tuned using the arrow keys (',
                              ),
                              WidgetSpan(child: Icon(Icons.arrow_circle_left_outlined)),
                              WidgetSpan(child: Icon(Icons.arrow_circle_up_outlined)),
                              WidgetSpan(child: Icon(Icons.arrow_circle_down_outlined)),
                              WidgetSpan(child: Icon(Icons.arrow_circle_right_outlined)),
                              TextSpan(text: ').'), //
                              TextSpan(text: '\nYou can also remove any of the selected item from the output tileset by clicking the '),
                              WidgetSpan(child: Icon(Icons.delete_outline)),
                              TextSpan(text: ' button or hit the DEL key.'), //
                              TextSpan(text: '\n\nTip: Using the WASD keys you can always move the image, even if one of the piece is selected.'),
                              TextSpan(text: '\n\nSupported elements:\n'), //
                              WidgetSpan(child: Icon(Icons.square_rounded, color: EditorColor.tile.color, size: 15)),
                              TextSpan(text: ' Input TileSet\'s Tile\n'), //
                              WidgetSpan(child: Icon(Icons.square_rounded, color: EditorColor.slice.color, size: 15)),
                              TextSpan(text: ' Input TileSet\'s Slice\n'), //
                              WidgetSpan(child: Icon(Icons.square_rounded, color: EditorColor.group.color, size: 15)),
                              TextSpan(text: ' Input TileSet\'s Group\n'), //
                              WidgetSpan(child: Icon(Icons.square_rounded, color: EditorColor.file.color, size: 15)),
                              TextSpan(text: ' Input TileGroup\'s File\n'), //
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
