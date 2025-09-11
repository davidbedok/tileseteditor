import 'dart:ui' as dui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/items/tilegroup_file.dart';
import 'package:tileseteditor/group/group_controller.dart';
import 'package:tileseteditor/group/group_state.dart';
import 'package:tileseteditor/utils/image_utils.dart';
import 'package:tileseteditor/widgets/tile_group_list_widget.dart';
import 'package:tileseteditor/project/selector.dart';
import 'package:path/path.dart' as path;

class GroupEditor extends StatefulWidget {
  static const double rightSideWidth = 400.0;

  final TileSetProject project;
  final TileGroup tileGroup;
  final GroupState groupState;
  final void Function() onOutputPressed;

  const GroupEditor({
    super.key, //
    required this.project,
    required this.tileGroup,
    required this.groupState,
    required this.onOutputPressed,
  });

  @override
  State<GroupEditor> createState() => _GroupEditorState();
}

class _GroupEditorState extends State<GroupEditor> {
  List<TileGroupFile> files = [];
  List<TileGroupFile> selectedFiles = [];
  TileGroupFile? current;

  @override
  void initState() {
    super.initState();
    files.addAll(widget.tileGroup.files);
    selectedFiles.addAll(widget.groupState.selectedFiles);
    widget.groupState.subscribeSelectioAll(selectionAll);
  }

  @override
  void dispose() {
    super.dispose();
    widget.groupState.unsubscribeSelectionAll(selectionAll);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GroupController(
              project: widget.project, //
              tileGroup: widget.tileGroup,
              groupState: widget.groupState,
              onOutputPressed: widget.onOutputPressed,
              onAddTiles: addTiles,
              onRemoveTiles: removeTiles,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - GroupEditor.rightSideWidth - 40,
                  height: MediaQuery.of(context).size.height - ProjectSelector.topHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: files.isEmpty
                          ? Text('Add Tiles (*.png) for this tilegroup..')
                          : ListView(
                              children: [
                                for (TileGroupFile groupFile in files)
                                  TileGroupListWidget(
                                    groupFile: groupFile, //
                                    selected: isSelected(groupFile),
                                    onClick: () {
                                      widget.groupState.selectTileGroupFile(groupFile);
                                      setState(() {
                                        if (isSelected(groupFile)) {
                                          selectedFiles.remove(groupFile);
                                        } else {
                                          selectedFiles.add(groupFile);
                                        }
                                        current = groupFile;
                                      });
                                    },
                                  ), //
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 20), //
                SizedBox(
                  width: GroupEditor.rightSideWidth,
                  height: MediaQuery.of(context).size.height - ProjectSelector.topHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: current != null
                          ? ListView(
                              children: [
                                Row(
                                  children: [
                                    Text('ID:', style: Theme.of(context).textTheme.labelLarge), //
                                    SizedBox(width: 5),
                                    Text('${current!.id}'),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text('Unique key:', style: Theme.of(context).textTheme.labelLarge), //
                                    SizedBox(width: 5),
                                    Text('${current!.key}'),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text('Path:', style: Theme.of(context).textTheme.labelLarge), //
                                    SizedBox(width: 5),
                                    Flexible(child: Text(current!.filePath)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text('Image size:', style: Theme.of(context).textTheme.labelLarge), //
                                    SizedBox(width: 5),
                                    Text(current!.imageSize.toString()),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text('Tiles:', style: Theme.of(context).textTheme.labelLarge), //
                                    SizedBox(width: 5),
                                    Text(
                                      '${current!.size.toString()} (${current!.size.getNumberOfIndices()} tile${current!.size.getNumberOfIndices() > 1 ? 's' : ''})',
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: RawImage(image: current!.image, height: 200),
                                ),
                                SizedBox(height: 50),
                              ],
                            )
                          : Row(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void addTiles() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowedExtensions: ['png'],
      dialogTitle: 'Open Tiles',
      type: FileType.custom,
      lockParentWindow: true,
    );
    if (filePickerResult != null) {
      List<TileGroupFile> newFiles = [];
      int nextId = widget.tileGroup.getNextFileId();
      int nextKey = widget.project.getNextKey();
      for (PlatformFile file in filePickerResult.files) {
        if (file.path != null) {
          dui.Image image = await ImageUtils.getImage(widget.project.buildFilePath(file.path!));
          PixelSize imageSize = PixelSize(image.width, image.height);
          TileGroupFile groupFile = TileGroupFile(
            id: nextId++, //
            key: nextKey++, //
            filePath: path.relative(file.path!, from: widget.project.getDirectory()),
            imageSize: imageSize,
            size: widget.tileGroup.calcGroupFileSize(imageSize),
          );
          groupFile.image = image;
          groupFile.initTileIndices();

          newFiles.add(groupFile);
        }
      }
      if (newFiles.isNotEmpty) {
        widget.tileGroup.files.addAll(newFiles);
        setState(() {
          files.addAll(newFiles);
        });
      }
    }
  }

  void removeTiles() {
    for (TileGroupFile file in widget.groupState.selectedFiles) {
      widget.tileGroup.files.remove(file);
      if (current == file) {
        setState(() {
          current = null;
        });
      }
    }
    widget.groupState.deselectAll();
    setState(() {
      selectedFiles.clear();
      files.clear();
      files.addAll(widget.tileGroup.files);
    });
  }

  bool isSelected(TileGroupFile groupFile) {
    return selectedFiles.where((file) => file.id == groupFile.id).isNotEmpty;
  }

  void selectionAll(GroupState groupState, bool select) {
    setState(() {
      current = null;
      if (select) {
        selectedFiles.clear();
        selectedFiles.addAll(groupState.selectedFiles);
      } else {
        selectedFiles.clear();
      }
    });
  }
}
