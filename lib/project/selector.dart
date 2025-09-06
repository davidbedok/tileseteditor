import 'dart:convert';
import 'dart:io';
import 'dart:ui' as dui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/dialogs/add_tileset_dialog.dart';
import 'package:tileseteditor/dialogs/edit_project_dialog.dart';
import 'package:tileseteditor/dialogs/edit_tileset_dialog.dart';
import 'package:tileseteditor/dialogs/new_project_dialog.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/project/editor.dart';
import 'package:tileseteditor/project/menubar.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/overview/overview_editor.dart';
import 'package:tileseteditor/overview/overview_state.dart';
import 'package:tileseteditor/project/project_controller.dart';
import 'package:tileseteditor/project/project_state.dart';
import 'package:tileseteditor/splitter/splitter_state.dart';
import 'package:tileseteditor/utils/image_utils.dart';
import 'package:tileseteditor/widgets/welcome_widget.dart';

class TileSetSelector extends StatefulWidget {
  final PackageInfo packageInfo;

  const TileSetSelector({super.key, required this.packageInfo});

  @override
  State<TileSetSelector> createState() => TileSetSelectorState();
}

class TileSetSelectorState extends State<TileSetSelector> {
  ProjectState projectState = ProjectState();
  SplitterState splitterState = SplitterState();
  OutputState outputState = OutputState();
  OverviewState overviewState = OverviewState();

  @override
  void initState() {
    super.initState();
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
                    projectState: projectState,
                    onNewProject: newProject,
                    onOpenProject: openProject,
                    onSaveProject: saveProject,
                    onSaveAsProject: saveAsProject,
                    onEditProject: editProject,
                    onCloseProject: closeProject,
                    onAddTileSet: addTileSet,
                    onEditTileSet: editTileSet,
                    onDeleteTileSet: deleteTileSet,
                    onAddTiles: addTiles,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: projectState.project.isNotDefined()
                      ? WelcomeWidget(
                          onNewProject: newProject, //
                          onOpenProject: openProject,
                        )
                      : ProjectController(
                          projectState: projectState,
                          onAddTileSet: addTileSet,
                          onCloseProject: closeProject,
                          onEditProject: editProject,
                          onEditTileSet: editTileSet,
                          onDeleteTileSet: deleteTileSet,
                        ),
                ),
              ],
            ),
            Visibility(
              visible: projectState.project.isDefined(),
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
                              value: projectState.tileSet.object,
                              hint: Text('Choose a TileSet..'),
                              style: Theme.of(context).textTheme.bodyMedium,
                              focusColor: Colors.transparent,
                              isDense: true,
                              isExpanded: true,
                              items: projectState.project.isNotDefined()
                                  ? []
                                  : projectState.project.object.getTileSetsDropDownItems().map((TileSet tileSetItem) {
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
                                    splitterState = SplitterState();
                                    outputState = OutputState();
                                    projectState.tileSet.select(value);
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
            projectState.tileSet.isDefined() && projectState.tileSet.object.image != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TileSetEditor(
                      key: GlobalKey(),
                      splitterState: splitterState, //
                      outputState: outputState,
                      project: projectState.project.object,
                      tileSet: projectState.tileSet.object,
                    ),
                  )
                : projectState.project.isDefined() && projectState.tileSet.isNotDefined()
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OverviewEditor(
                      key: GlobalKey(),
                      overviewState: overviewState, //
                      project: projectState.project.object,
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
        projectState.project.select(dialogResult);
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
        loadedProject.filePath = filePickerResult.files.single.path!;
        await loadedProject.loadTileSetImages();
        setState(() {
          projectState.project.select(loadedProject);
        });
      }
    }
  }

  void saveProject() async {
    if (projectState.project.isDefined()) {
      if (projectState.project.object.filePath != null) {
        File file = File(projectState.project.object.filePath!);
        if (file.existsSync()) {
          file.writeAsString(prettyJson(projectState.project.object.toJson(widget.packageInfo)));
        } else {
          saveAsProject();
        }
      } else {
        saveAsProject();
      }
    }
  }

  void saveAsProject() async {
    if (projectState.project.isDefined()) {
      TileSetProject savedProject = projectState.project.object;
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
          projectState.project.select(savedProject);
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
    if (projectState.project.isDefined()) {
      TileSetProject? dialogResult = await showDialog<TileSetProject>(
        context: context,
        builder: (BuildContext context) {
          return EditProjectDialog(project: TileSetProject.clone(projectState.project.object));
        },
      );
      if (dialogResult != null) {
        setState(() {
          projectState.project.object.name = dialogResult.name;
          projectState.project.object.description = dialogResult.description;
          projectState.project.object.output.fileName = dialogResult.output.fileName;
          projectState.project.object.output.width = dialogResult.output.width;
          projectState.project.object.output.height = dialogResult.output.height;
        });
      }
    }
  }

  void closeProject() {
    setState(() {
      projectState.project.select(TileSetProject.none);
      projectState.tileSet.select(TileSet.none);
      splitterState = SplitterState();
      outputState = OutputState();
    });
  }

  void addTileSet() async {
    if (projectState.project.isDefined()) {
      TileSet? dialogResult = await showDialog<TileSet>(
        context: context,
        builder: (BuildContext context) {
          return AddTileSetDialog(project: projectState.project.object);
        },
      );
      if (dialogResult != null) {
        dui.Image image = await ImageUtils.getImage(projectState.project.object.getTileSetFilePath(dialogResult));
        dialogResult.imageWidth = image.width;
        dialogResult.imageHeight = image.height;
        await dialogResult.loadImage(projectState.project.object);
        setState(() {
          projectState.project.object.addTileSet(dialogResult);
          projectState.tileSet.select(dialogResult);
        });
      }
    }
  }

  void editTileSet() async {
    if (projectState.project.isDefined() && projectState.tileSet.isDefined()) {
      TileSet? dialogResult = await showDialog<TileSet>(
        context: context,
        builder: (BuildContext context) {
          return EditTileSetDialog(project: projectState.project.object, tileSet: TileSet.clone(projectState.tileSet.object));
        },
      );
      if (dialogResult != null) {
        setState(() {
          projectState.tileSet.object.name = dialogResult.name;
          projectState.tileSet.object.active = dialogResult.active;
        });
      }
    }
  }

  void deleteTileSet() async {
    if (projectState.project.isDefined() && projectState.tileSet.isDefined()) {
      setState(() {
        projectState.project.object.deleteTileSet(projectState.tileSet.object);
        projectState.tileSet.select(TileSet.none);
      });
    }
  }

  void addTiles() async {
    //
  }
}
