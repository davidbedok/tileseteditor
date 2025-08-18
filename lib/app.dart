import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/dialogs/edit_project_dialog.dart';
import 'package:tileseteditor/dialogs/new_project_dialog.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/menubar.dart';

class TileSetEditorApp extends StatefulWidget {
  final PackageInfo packageInfo;

  const TileSetEditorApp({super.key, required this.packageInfo});

  @override
  State<TileSetEditorApp> createState() => _TileSetEditorAppState();
}

class _TileSetEditorAppState extends State<TileSetEditorApp> {
  TileSetProject? project;

  @override
  void initState() {
    super.initState();
    project = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: TileSetEditorMenuBar(
                    project: project,
                    onNewProject: newProject,
                    onOpenProject: openProject,
                    onSaveProject: saveProject,
                    onSaveAsProject: saveAsProject,
                    onEditProject: editProject,
                    onCloseProject: closeProject,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 200,
                          child: Container(color: Colors.blue, child: Text('Row 1 | Col 1')),
                        ),
                        SizedBox(
                          width: 300,
                          height: 200,
                          child: Container(color: Colors.red, child: Text('Row 1 | Col 2')),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Container(color: Colors.amber, child: Text('Row 2')),
                        ),
                      ],
                    ),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('hello');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void newProject() async {
    TileSetProject? dialogResult = await showDialog<TileSetProject>(
      context: context,
      builder: (BuildContext context) {
        return NewProjectDialog();
      },
    );
    if (dialogResult != null) {
      setState(() {
        project = dialogResult;
      });
    }
  }

  void openProject() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['tsp'],
      dialogTitle: 'Open Tile Set Project',
      type: FileType.custom,
    );
    if (filePickerResult != null) {
      File file = File(filePickerResult.files.single.path!);
      if (file.existsSync()) {
        String content = await file.readAsString();
        setState(() {
          project = TileSetProject.fromJson(jsonDecode(content) as Map<String, dynamic>);
          project!.filePath = filePickerResult.files.single.path!;
        });
      }
    }
  }

  void saveProject() async {
    if (project != null) {
      if (project!.filePath != null) {
        File file = File(project!.filePath!);
        if (file.existsSync()) {
          file.writeAsString(prettyJson(project!.toJson(widget.packageInfo)));
        } else {
          saveAsProject();
        }
      } else {
        saveAsProject();
      }
    }
  }

  void saveAsProject() async {
    if (project != null) {
      project!.filePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Tile Set Project',
        allowedExtensions: ['tsp'],
        fileName: '${project!.name}.tsp',
        type: FileType.custom,
      );
      if (project!.filePath != null) {
        File file = File(project!.filePath!);
        file.writeAsString(prettyJson(project!.toJson(widget.packageInfo)));
      }
    }
  }

  String prettyJson(dynamic json) {
    var spaces = ' ' * 4;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }

  void editProject() async {
    if (project != null) {
      TileSetProject? dialogResult = await showDialog<TileSetProject>(
        context: context,
        builder: (BuildContext context) {
          return EditProjectDialog(project: TileSetProject.clone(project!));
        },
      );
      if (dialogResult != null) {
        setState(() {
          project = dialogResult;
        });
      }
    }
  }

  void closeProject() {
    setState(() {
      project = null;
    });
  }
}
