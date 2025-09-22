import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/generator/generator_controller.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/project/selector.dart';
import 'package:tileseteditor/widgets/cli_box.dart';
import 'package:tileseteditor/widgets/fixed_information_box.dart';
import 'package:tileseteditor/widgets/information_box.dart';

class GeneratorEditor extends StatelessWidget {
  static const double sideWidth = 250;

  final PackageInfo packageInfo;
  final YateProject project;
  final OutputState outputState;
  final void Function() onOverviewPressed;

  const GeneratorEditor({
    super.key, //
    required this.packageInfo,
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
              packageInfo: packageInfo,
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            children: [
                              FixedInformationBox(
                                infoIcon: false,
                                texts: [
                                  TextSpan(
                                    text: 'Build project\n',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ), //
                                  TextSpan(
                                    text:
                                        'This command will build the ${project.output.fileName} and put into the target directory. Defining an empty tile image is mandatory.\n',
                                  ),
                                  TextSpan(text: 'Building the project executes automatically the clean, split and generate subcommands.'), //
                                ],
                              ),
                              CliBox(
                                texts: [
                                  'python yatecli.py --mode build --empty .\\empty\\empty_${project.output.tileSize.widthPx}x${project.output.tileSize.heightPx}.png --project ${project.filePath} --target output',
                                ],
                              ),
                              SizedBox(height: 10),
                              FixedInformationBox(
                                infoIcon: false,
                                texts: [
                                  TextSpan(
                                    text: 'Creating tiles\n',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ), //
                                  TextSpan(
                                    text:
                                        'Use this helper command if you want to split all of your input images (tileset images and all the files within tilegroups) into ${project.output.tileSize.widthPx}x${project.output.tileSize.heightPx} tiles.\n',
                                  ), //
                                  TextSpan(
                                    text:
                                        'With the help of this command you can create tile images what you want to use later in a TileGroup, or just simply use one of the tile as empty tile in the build command.',
                                  ),
                                ],
                              ),
                              CliBox(texts: ['python yatecli.py --mode tiles --project ${project.filePath} --target output']),
                              SizedBox(height: 30),
                              FixedInformationBox(
                                infoIcon: false,
                                texts: [
                                  TextSpan(text: 'Subcommand: '),
                                  TextSpan(
                                    text: 'Clean project\n',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ), //
                                  TextSpan(
                                    text:
                                        'Use it when you want to (re)create the target directory. This will delete all previously generated images wihtin the target directory.',
                                  ), //
                                ],
                              ),
                              CliBox(
                                texts: [
                                  'python yatecli.py --mode clean --project ${project.filePath} --target output', //
                                ],
                              ),
                              SizedBox(height: 10),
                              FixedInformationBox(
                                infoIcon: false,
                                texts: [
                                  TextSpan(text: 'Subcommand: '),
                                  TextSpan(
                                    text: 'Split elements\n',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ), //
                                  TextSpan(
                                    text:
                                        'Use this helper command if you want to create all slices, groups and individual tiles what are needed for the ${project.output.fileName} output tileset image. The output tileset won\'t be created.',
                                  ), //
                                ],
                              ),
                              CliBox(texts: ['python yatecli.py --mode split --project ${project.filePath} --target output']),
                              SizedBox(height: 10),
                              FixedInformationBox(
                                infoIcon: false,
                                texts: [
                                  TextSpan(text: 'Subcommand: '),
                                  TextSpan(
                                    text: 'Generate output\n',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ), //
                                  TextSpan(
                                    text:
                                        'Use this helper command if you want to generate ${project.output.fileName} output tileset image only, without building the input sources. You must call project splitter before use this command.',
                                  ), //
                                ],
                              ),
                              CliBox(
                                texts: [
                                  'python yatecli.py --mode generate --empty .\\empty\\empty_${project.output.tileSize.widthPx}x${project.output.tileSize.heightPx}.png --project ${project.filePath} --target output',
                                ],
                              ),
                            ],
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
                              TextSpan(text: 'Here in the '), //
                              TextSpan(
                                text: 'Generator',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ), //
                              TextSpan(text: ' screen, you can see all the YATE CLI commands what you need for generating the output TileSet image.\n'), //
                              TextSpan(
                                text:
                                    '\nBefore you execute these commands, make sure that Python 3.x and ImageMagick are already installed in your computer. Do not forget to add both tools into your PATH variable.',
                              ), //
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
