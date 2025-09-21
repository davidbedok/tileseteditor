import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/generator/generator_controller.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/project/selector.dart';
import 'package:tileseteditor/widgets/information_box.dart';

class GeneratorEditor extends StatelessWidget {
  static const double sideWidth = 250;

  final YateProject project;
  final OutputState outputState;
  final void Function() onOverviewPressed;

  const GeneratorEditor({
    super.key, //
    required this.project,
    required this.outputState,
    required this.onOverviewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GeneratorController(
              project: project, //
              outputState: outputState,
              onOverviewPressed: onOverviewPressed,
            ),
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - sideWidth - 30,
                      height: MediaQuery.of(context).size.height - ProjectSelector.topHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(padding: const EdgeInsets.all(8.0), child: Text('Lorem ipsum...')),
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
                                text: 'Generator',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ), //
                              TextSpan(text: ' lorem ipsum...'), //
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
