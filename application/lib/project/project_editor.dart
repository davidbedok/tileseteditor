import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/generator/generator_editor.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/overview/overview_editor.dart';

class ProjectEditor extends StatefulWidget {
  final PackageInfo packageInfo;
  final YateProject project;
  final OutputState outputState;

  const ProjectEditor({
    super.key, //
    required this.packageInfo,
    required this.project,
    required this.outputState,
  });

  @override
  State<ProjectEditor> createState() => _ProjectEditorState();
}

class _ProjectEditorState extends State<ProjectEditor> {
  bool overviewEditor = true;

  @override
  Widget build(BuildContext context) {
    return overviewEditor
        ? OverviewEditor(
            key: GlobalKey(),
            outputState: widget.outputState, //
            project: widget.project,
            onGeneratePressed: () {
              setState(() {
                overviewEditor = false;
              });
            },
          )
        : GeneratorEditor(
            packageInfo: widget.packageInfo,
            project: widget.project,
            outputState: widget.outputState,
            onOverviewPressed: () {
              setState(() {
                overviewEditor = true;
              });
            },
          );
  }
}
