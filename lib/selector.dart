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
import 'package:tileseteditor/output/state/output_editor_state.dart';
import 'package:tileseteditor/overview/overview_editor.dart';
import 'package:tileseteditor/overview/overview_editor_state.dart';
import 'package:tileseteditor/project_action_controller.dart';
import 'package:tileseteditor/splitter/state/splitter_editor_state.dart';
import 'package:tileseteditor/utils/image_utils.dart';
import 'package:tileseteditor/widgets/welcome_widget.dart';

class TileSetSelector extends StatefulWidget {
  final PackageInfo packageInfo;

  const TileSetSelector({super.key, required this.packageInfo});

  @override
  State<TileSetSelector> createState() => TileSetSelectorState();
}

class TileSetSelectorState extends State<TileSetSelector> {
  TileSetProject? project;
  TileSet tileSet = TileSet.none;
  SplitterEditorState splitterState = SplitterEditorState();
  OutputEditorState outputState = OutputEditorState();
  OverviewEditorState overviewState = OverviewEditorState();

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
                      ? WelcomeWidget(
                          onNewProject: newProject, //
                          onOpenProject: openProject,
                        )
                      : ProjectActionController(
                          project: project!, //
                          onAddTileSet: addTileSet,
                          onCloseProject: closeProject,
                          onEditProject: editProject,
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
                                  : project!.getTileSetsDropDownItems().map((TileSet tileSetItem) {
                                      return DropdownMenuItem<TileSet>(
                                        value: tileSetItem, //
                                        child: Text(
                                          tileSetItem.key >= 0
                                              ? 'Splitter and output editor for ${tileSetItem.name} (${tileSetItem.key})'
                                              : 'Overview output editor',
                                        ),
                                      );
                                    }).toList(),
                              onChanged: (TileSet? value) async {
                                if (value != null) {
                                  setState(() {
                                    tileSet = value;
                                    splitterState = SplitterEditorState();
                                    outputState = OutputEditorState();
                                  });
                                }
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
            tileSet != TileSet.none && tileSet.image != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TileSetEditor(
                      key: GlobalKey(),
                      splitterState: splitterState, //
                      outputState: outputState,
                      project: project!,
                      tileSet: tileSet!,
                    ),
                  )
                : project != null && tileSet == TileSet.none
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OverviewEditor(
                      key: GlobalKey(),
                      overviewState: overviewState, //
                      project: project!,
                    ),
                  )
                : Row(),
          ],
        ),
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
      saveProject();
    }
  }

  void openProject() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['yate.json'],
      dialogTitle: 'Open TileSet Project',
      type: FileType.custom,
      lockParentWindow: true,
    );
    if (filePickerResult != null) {
      File file = File(filePickerResult.files.single.path!);
      if (file.existsSync()) {
        String content = await file.readAsString();
        TileSetProject loadedProject = TileSetProject.fromJson(jsonDecode(content) as Map<String, dynamic>);
        loadedProject!.filePath = filePickerResult.files.single.path!;
        await loadedProject!.loadTileSetImages();
        setState(() {
          project = loadedProject;
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
      TileSetProject savedProject = project!;
      savedProject.filePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Tile Set Project',
        allowedExtensions: ['yate.json'],
        fileName: '${savedProject.name}.yate.json',
        type: FileType.custom,
        lockParentWindow: true,
      );
      if (savedProject.filePath != null) {
        File file = File(savedProject.filePath!);
        file.writeAsString(prettyJson(savedProject.toJson(widget.packageInfo)));
        setState(() {
          project = savedProject;
        });
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
      tileSet = TileSet.none;
      splitterState = SplitterEditorState();
      outputState = OutputEditorState();
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
        await dialogResult.loadImage(project!);
      }
    }
  }
}
