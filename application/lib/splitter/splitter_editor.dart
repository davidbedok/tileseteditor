import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/project/selector.dart';
import 'package:tileseteditor/splitter/splitter_controller.dart';
import 'package:tileseteditor/splitter/splitter_datasheet.dart';
import 'package:tileseteditor/splitter/flame/splitter_game.dart';
import 'package:tileseteditor/splitter/splitter_state.dart';

class SplitterEditor extends StatelessWidget {
  static const double sideWidth = 300;

  final YateProject project;
  final TileSet tileSet;
  final SplitterState splitterState;
  final void Function() onOutputPressed;

  const SplitterEditor({
    super.key, //
    required this.project,
    required this.tileSet,
    required this.splitterState,
    required this.onOutputPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SplitterController(
              project: project, //
              splitterState: splitterState,
              tileSet: tileSet,
              onOutputPressed: onOutputPressed,
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
                          game: SplitterGame(
                            tileSet: tileSet,
                            width: MediaQuery.of(context).size.width - sideWidth - 30,
                            height: MediaQuery.of(context).size.height - ProjectSelector.topHeight,
                            splitterState: splitterState,
                          ),
                        ),
                      ),
                    ), //
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
                          child: Container(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                            child: SplitterDatasheet(
                              splitterState: splitterState, //
                              tileSet: tileSet,
                            ),
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
