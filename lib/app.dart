import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as dui;

import 'package:file_picker/file_picker.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/dialogs/add_group_dialog.dart';
import 'package:tileseteditor/dialogs/add_slice_dialog.dart';
import 'package:tileseteditor/dialogs/add_tileset_dialog.dart';
import 'package:tileseteditor/dialogs/edit_project_dialog.dart';
import 'package:tileseteditor/dialogs/new_project_dialog.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_group.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/flame/editor_game.dart';
import 'package:tileseteditor/menubar.dart';

class TileSetEditorApp extends StatefulWidget {
  final PackageInfo packageInfo;

  const TileSetEditorApp({super.key, required this.packageInfo});

  @override
  State<TileSetEditorApp> createState() => _TileSetEditorAppState();
}

class _TileSetEditorAppState extends State<TileSetEditorApp> {
  TileSetProject? project;
  TileSet? tileSet;
  // late Future<dui.Image> selectedTileSetImage;
  dui.Image? tileSetImage;

  List<TileCoord> selectedFreeTiles = [];
  List<TileCoord> selectedGarbageTiles = [];
  TileInfo? selectedTileInfo;

  @override
  void initState() {
    super.initState();
    project = null;
    // selectedTileSetImage = getImage('D:\tilesetprojects\example\magecity.png');
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Text(
                          project == null ? 'Please create or open a TileSet Project.' : '${project!.name} TileSet Project',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: project != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(child: Text("TileSet", style: Theme.of(context).textTheme.bodyMedium)),
                          SizedBox(width: 10),
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
                                      var image = await getImage(value!.filePath);
                                      setState(() {
                                        tileSet = value;
                                        // selectedTileSetImage = getImage(tileSet!.filePath);
                                        tileSetImage = image;
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
                    SizedBox(height: 10),
                    Visibility(
                      visible: tileSetImage != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.add_circle_outline),
                            label: const Text('Slice'),
                            onPressed: selectedTileInfo != null
                                ? null
                                : () {
                                    if (selectedFreeTiles.isNotEmpty) {
                                      addSlice();
                                    }
                                  },
                          ),
                          SizedBox(width: 5),
                          ElevatedButton.icon(
                            icon: Icon(Icons.add_circle_outline),
                            label: const Text('Group'),
                            onPressed: selectedTileInfo != null
                                ? null
                                : () {
                                    if (selectedFreeTiles.isNotEmpty) {
                                      addGroup();
                                    }
                                  },
                          ),
                          SizedBox(width: 5),
                          ElevatedButton.icon(
                            icon: Icon(Icons.cancel),
                            label: const Text('Drop'),
                            onPressed: selectedTileInfo != null
                                ? null
                                : () {
                                    if (selectedFreeTiles.isNotEmpty) {
                                      setState(() {
                                        tileSet!.addGarbage(selectedFreeTiles);
                                        selectedFreeTiles.clear();
                                      });
                                    }
                                  },
                          ),
                          SizedBox(width: 5),
                          ElevatedButton.icon(
                            icon: Icon(Icons.cancel_outlined),
                            label: const Text('Undrop'),
                            onPressed: selectedTileInfo != null
                                ? null
                                : () {
                                    if (selectedGarbageTiles.isNotEmpty) {
                                      setState(() {
                                        tileSet!.removeGarbage(selectedGarbageTiles);
                                        selectedGarbageTiles.clear();
                                      });
                                    }
                                  },
                          ),
                          SizedBox(width: 5),
                          ElevatedButton.icon(
                            icon: Icon(Icons.delete),
                            label: const Text('Delete'),
                            onPressed: selectedTileInfo == null
                                ? null
                                : () {
                                    setState(() {
                                      tileSet!.remove(selectedTileInfo!);
                                      selectedTileInfo = null;
                                    });
                                  },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    tileSet != null && tileSetImage != null
                        ? Row(
                            children: [
                              SizedBox(
                                width: 450,
                                height: MediaQuery.of(context).size.height - 200,
                                child: Container(
                                  margin: const EdgeInsets.all(0),
                                  padding: const EdgeInsets.all(0),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                  child: GameWidget(
                                    game: EditorGame(
                                      tileSet: tileSet!,
                                      onSelectTile: selectTile,
                                      width: 400,
                                      height: MediaQuery.of(context).size.height - 250,
                                      tileSetImage: tileSetImage,
                                      selectedFreeTiles: selectedFreeTiles,
                                      selectedTileInfo: selectedTileInfo,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 500,
                                height: MediaQuery.of(context).size.height - 200,
                                child: Container(
                                  margin: const EdgeInsets.all(0),
                                  padding: const EdgeInsets.all(0),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                  child: ListView(
                                    children: [
                                      Row(
                                        children: [
                                          Text('Image size:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 5),
                                          Text('${tileSet!.imageWidth} x ${tileSet!.imageHeight}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Tile size:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 5),
                                          Text('${tileSet!.tileWidth} x ${tileSet!.tileHeight}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Max tile:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 5),
                                          Text('${tileSet!.getMaxTileColumn()} x ${tileSet!.getMaxTileRow()}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Number of slices:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 5),
                                          Text('${tileSet!.slices.length}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Number of groups:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 5),
                                          Text('${tileSet!.groups.length}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Number of garbages:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 5),
                                          Text('${tileSet!.garbage.indices.length}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Selected:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 5),
                                          Text(selectedTileInfo != null ? '${selectedTileInfo!.name} (${selectedTileInfo!.type.name})' : '-'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(height: 0),
                    SizedBox(height: 20),
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
      selectedFreeTiles.clear();
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
        dui.Image image = await getImage(dialogResult.filePath);
        dialogResult.imageWidth = image.width;
        dialogResult.imageHeight = image.height;
        setState(() {
          project!.addTileSet(dialogResult);
        });
      }
    }
  }

  Future<dui.Image> getImage(String path) async {
    Completer<ImageInfo> completer = Completer();
    Image img = Image.file(File(path));
    img.image
        .resolve(ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            completer.complete(info);
          }),
        );
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  void selectTile(bool selected, TileInfo info) {
    switch (info.type) {
      case TileType.free:
        // setState(() {
        if (selected) {
          selectedFreeTiles.add(info.coord);
        } else {
          selectedFreeTiles.removeWhere((c) => c.x == info.coord.x && c.y == info.coord.y);
        }
      // });
      case TileType.slice:
      case TileType.group:
        if (selectedTileInfo == null) {
          setState(() {
            selectedFreeTiles.clear();
            selectedTileInfo = info;
          });
        } else {
          if (selectedTileInfo == info) {
            setState(() {
              selectedFreeTiles.clear();
              selectedTileInfo = null;
            });
          }
        }
      case TileType.garbage:
        if (selected) {
          print('select garbage');
          selectedGarbageTiles.add(info.coord);
        } else {
          print('unselect garbage');
          selectedGarbageTiles.removeWhere((c) => c.x == info.coord.x && c.y == info.coord.y);
        }
    }
  }

  void addSlice() async {
    if (project != null && tileSet != null) {
      TileSetSlice? dialogResult = await showDialog<TileSetSlice>(
        context: context,
        builder: (BuildContext context) {
          return AddSliceDialog(tileSet: tileSet!, tiles: selectedFreeTiles);
        },
      );
      if (dialogResult != null) {
        setState(() {
          tileSet!.addSlice(dialogResult);
          selectedFreeTiles.clear();
        });
      }
    }
  }

  void addGroup() async {
    if (project != null && tileSet != null) {
      TileSetGroup? dialogResult = await showDialog<TileSetGroup>(
        context: context,
        builder: (BuildContext context) {
          return AddGroupDialog(tileSet: tileSet!, tiles: selectedFreeTiles);
        },
      );
      if (dialogResult != null) {
        setState(() {
          tileSet!.addGroup(dialogResult);
          selectedFreeTiles.clear();
        });
      }
    }
  }
}
