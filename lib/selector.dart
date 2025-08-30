import 'dart:convert';
import 'dart:io';
import 'dart:ui' as dui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/dialogs/add_tileset_dialog.dart';
import 'package:tileseteditor/dialogs/edit_project_dialog.dart';
import 'package:tileseteditor/dialogs/new_project_dialog.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/editor.dart';
import 'package:tileseteditor/menubar.dart';
import 'package:tileseteditor/splitter/state/editor_state.dart';
import 'package:tileseteditor/utils/image_utils.dart';

class TileSetSelector extends StatefulWidget {
  final PackageInfo packageInfo;

  const TileSetSelector({super.key, required this.packageInfo});

  @override
  State<TileSetSelector> createState() => TileSetSelectorState();
}

class TileSetSelectorState extends State<TileSetSelector> {
  TileSetProject? project;
  TileSet? tileSet;
  dui.Image? tileSetImage;
  EditorState editorState = EditorState();

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
                    onAddTileSet: addTileSet,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: project == null
                      ? Text('Please create or open a TileSet Project (*.tsp.json).', style: Theme.of(context).textTheme.bodyMedium)
                      : RichText(
                          text: TextSpan(
                            text: 'TileSet Project: ',
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: <TextSpan>[
                              TextSpan(
                                text: project!.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '. Please select or add a TileSet (*.png).'),
                            ],
                          ),
                        ),
                ),
              ],
            ),
            Visibility(
              visible: project != null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                          contentPadding: EdgeInsets.all(5),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            splashColor: Colors.transparent, //
                            highlightColor: Colors.transparent, //
                            hoverColor: Colors.transparent, //
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<TileSet>(
                              value: tileSet,
                              hint: Text('Choose a TileSet..'),
                              style: Theme.of(context).textTheme.bodyMedium,
                              focusColor: Colors.transparent,
                              isDense: true,
                              isExpanded: true,
                              items: project == null
                                  ? []
                                  : project!.tileSets.map((TileSet tileSetItem) {
                                      return DropdownMenuItem<TileSet>(value: tileSetItem, child: Text(tileSetItem.name));
                                    }).toList(),
                              onChanged: (value) async {
                                var image = await ImageUtils.getImage(project!.getTileSetFilePath(value!));
                                setState(() {
                                  tileSet = value;
                                  tileSetImage = image;
                                  editorState = EditorState();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            tileSet != null && tileSetImage != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TileSetEditor(
                      key: GlobalKey(),
                      editorState: editorState, //
                      project: project!,
                      tileSet: tileSet!,
                      tileSetImage: tileSetImage!,
                    ),
                  )
                : Row(),
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
      allowedExtensions: ['tsp.json'],
      dialogTitle: 'Open TileSet Project',
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
        allowedExtensions: ['tsp.json'],
        fileName: '${project!.name}.tsp.json',
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
      tileSet = null;
      tileSetImage = null;
      editorState = EditorState();
    });
  }

  void addTileSet() async {
    if (project != null) {
      TileSet? dialogResult = await showDialog<TileSet>(
        context: context,
        builder: (BuildContext context) {
          return AddTileSetDialog(project: project!);
        },
      );
      if (dialogResult != null) {
        dui.Image image = await ImageUtils.getImage(project!.getTileSetFilePath(dialogResult));
        dialogResult.imageWidth = image.width;
        dialogResult.imageHeight = image.height;
        setState(() {
          project!.addTileSet(dialogResult);
        });
      }
    }
  }
}
