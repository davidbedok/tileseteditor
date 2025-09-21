import 'dart:convert';
import 'dart:io';
import 'dart:ui' as dui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/dialogs/add_tilegroup_dialog.dart';
import 'package:tileseteditor/dialogs/add_tileset_dialog.dart';
import 'package:tileseteditor/dialogs/edit_project_dialog.dart';
import 'package:tileseteditor/dialogs/edit_tilegroup_dialog.dart';
import 'package:tileseteditor/dialogs/edit_tileset_dialog.dart';
import 'package:tileseteditor/dialogs/new_project_dialog.dart';
import 'package:tileseteditor/domain/project_item.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/builder/builder_state.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/project/project_editor.dart';
import 'package:tileseteditor/project/tilegroup_editor.dart';
import 'package:tileseteditor/project/tileset_editor.dart';
import 'package:tileseteditor/project/menubar.dart';
import 'package:tileseteditor/overview/overview_editor.dart';
import 'package:tileseteditor/project/project_controller.dart';
import 'package:tileseteditor/project/project_state.dart';
import 'package:tileseteditor/splitter/splitter_state.dart';
import 'package:tileseteditor/utils/image_utils.dart';
import 'package:tileseteditor/widgets/welcome_widget.dart';

class ProjectSelector extends StatefulWidget {
  static const int topHeight = 230;

  final PackageInfo packageInfo;

  const ProjectSelector({super.key, required this.packageInfo});

  @override
  State<ProjectSelector> createState() => ProjectSelectorState();
}

class ProjectSelectorState extends State<ProjectSelector> {
  ProjectState projectState = ProjectState();
  SplitterState splitterState = SplitterState();
  BuilderState builderState = BuilderState();
  OutputState outputState = OutputState();

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
                  child: ProjectMenuBar(
                    packageInfo: widget.packageInfo,
                    projectState: projectState,
                    onNewProject: newProject,
                    onOpenProject: openProject,
                    onSaveProject: saveProject,
                    onSaveAsProject: saveAsProject,
                    onCloseProject: closeProject,
                    onEditProject: editProject,
                    onAddTileSet: addTileSet,
                    onEditTileSet: editTileSet,
                    onDeleteTileSet: deleteTileSet,
                    onAddTileGroup: addTileGroup,
                    onEditTileGroup: editTileGroup,
                    onDeleteTileGroup: deleteTileGroup,
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
                          packageInfo: widget.packageInfo,
                          onNewProject: newProject, //
                          onOpenProject: openProject,
                        )
                      : ProjectController(
                          projectState: projectState,
                          onEditProject: editProject,
                          onAddTileSet: addTileSet,
                          onAddTileGroup: addTileGroup,
                          onEditTileSet: editTileSet,
                          onDeleteTileSet: deleteTileSet,
                          onEditTileGroup: editTileGroup,
                          onDeleteTileGroup: deleteTileGroup,
                          onCloseProject: closeProject,
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
                            child: DropdownButton<YateProjectItem>(
                              value: projectState.item.object,
                              hint: Text('Choose a tileset or a tilegroup..'),
                              style: Theme.of(context).textTheme.bodyMedium,
                              focusColor: Colors.transparent,
                              isDense: true,
                              isExpanded: true,
                              items: projectState.project.isNotDefined()
                                  ? []
                                  : projectState.project.object.getProjectItemsDropDown().map((YateProjectItem projectItem) {
                                      return DropdownMenuItem<YateProjectItem>(
                                        value: projectItem, //
                                        child: projectItem.id >= 0
                                            ? RichText(
                                                text: TextSpan(
                                                  text: projectItem.getDropDownPrefix(),
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                  children: <TextSpan>[
                                                    TextSpan(text: ' for '),
                                                    TextSpan(
                                                      text: projectItem.name,
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    TextSpan(text: ' | ${projectItem.getDetails()}'),
                                                  ],
                                                ),
                                              )
                                            : Text('Overview output editor'),
                                      );
                                    }).toList(),
                              onChanged: (YateProjectItem? value) async {
                                if (value != null) {
                                  setState(() {
                                    splitterState = SplitterState();
                                    builderState = BuilderState();
                                    outputState = OutputState();
                                    projectState.item.select(value);
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
            projectState.project.isDefined()
                ? projectState.item.object.isTileSet() && projectState.getItemAsTileSet().image != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TileSetEditor(
                            key: GlobalKey(),
                            splitterState: splitterState, //
                            outputState: outputState,
                            project: projectState.project.object,
                            tileSet: projectState.getItemAsTileSet(),
                          ),
                        )
                      : projectState.item.object.isTileGroup()
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TileGroupEditor(
                            key: GlobalKey(),
                            builderState: builderState, //
                            outputState: outputState,
                            project: projectState.project.object,
                            tileGroup: projectState.getItemAsTileGroup(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProjectEditor(
                            key: GlobalKey(),
                            outputState: outputState, //
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
    YateProject? dialogResult = await showDialog<YateProject>(
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
        YateProject loadedProject = YateProject.fromJson(jsonDecode(content) as Map<String, dynamic>);
        loadedProject.filePath = filePickerResult.files.single.path!;
        await loadedProject.loadAllImages();
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
      YateProject savedProject = projectState.project.object;
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
      YateProject? dialogResult = await showDialog<YateProject>(
        context: context,
        builder: (BuildContext context) {
          return EditProjectDialog(project: YateProject.clone(projectState.project.object));
        },
      );
      if (dialogResult != null) {
        setState(() {
          projectState.project.object.name = dialogResult.name;
          projectState.project.object.description = dialogResult.description;
          projectState.project.object.output.fileName = dialogResult.output.fileName;
          projectState.project.object.output.size.width = dialogResult.output.size.width;
          projectState.project.object.output.size.height = dialogResult.output.size.height;
        });
      }
    }
  }

  void closeProject() {
    setState(() {
      projectState.project.unselect();
      projectState.item.unselect();
      splitterState = SplitterState();
      outputState = OutputState();
      builderState = BuilderState();
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
        dui.Image image = await ImageUtils.getImage(projectState.project.object.getTileSetPath(dialogResult));
        dialogResult.imageSize.widthPx = image.width;
        dialogResult.imageSize.heightPx = image.height;
        await dialogResult.loadImage(projectState.project.object);
        setState(() {
          projectState.project.object.tileSets.add(dialogResult);
          projectState.item.select(dialogResult);
        });
      }
    }
  }

  void editTileSet() async {
    if (projectState.project.isDefined() && projectState.item.object.isTileSet()) {
      TileSet? dialogResult = await showDialog<TileSet>(
        context: context,
        builder: (BuildContext context) {
          return EditTileSetDialog(project: projectState.project.object, tileSet: TileSet.clone(projectState.getItemAsTileSet()));
        },
      );
      if (dialogResult != null) {
        setState(() {
          projectState.item.object.name = dialogResult.name;
          projectState.item.object.active = dialogResult.active;
        });
      }
    }
  }

  void deleteTileSet() async {
    if (projectState.project.isDefined() && projectState.item.isDefined()) {
      setState(() {
        projectState.project.object.deleteTileSet(projectState.getItemAsTileSet());
        projectState.item.unselect();
      });
    }
  }

  void addTileGroup() async {
    if (projectState.project.isDefined()) {
      TileGroup? dialogResult = await showDialog<TileGroup>(
        context: context,
        builder: (BuildContext context) {
          return AddTileGroupDialog(project: projectState.project.object);
        },
      );
      if (dialogResult != null) {
        setState(() {
          projectState.project.object.tileGroups.add(dialogResult);
          projectState.item.select(dialogResult);
        });
      }
    }
  }

  void editTileGroup() async {
    if (projectState.project.isDefined() && projectState.item.object.isTileGroup()) {
      TileGroup? dialogResult = await showDialog<TileGroup>(
        context: context,
        builder: (BuildContext context) {
          return EditTileGroupDialog(project: projectState.project.object, tileGroup: TileGroup.clone(projectState.getItemAsTileGroup()));
        },
      );
      if (dialogResult != null) {
        setState(() {
          projectState.item.object.name = dialogResult.name;
          projectState.item.object.active = dialogResult.active;
        });
      }
    }
  }

  void deleteTileGroup() async {
    if (projectState.project.isDefined() && projectState.item.object.isTileGroup()) {
      setState(() {
        projectState.project.object.deleteTileGroup(projectState.getItemAsTileGroup());
        projectState.item.unselect();
      });
    }
  }
}
