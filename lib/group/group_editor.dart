import 'dart:ui' as dui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tilesetitem/tilegroup_file.dart';
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

  const GroupEditor({
    super.key, //
    required this.project,
    required this.tileGroup,
    required this.groupState,
  });

  @override
  State<GroupEditor> createState() => _GroupEditorState();
}

class _GroupEditorState extends State<GroupEditor> {
  late TileGroup _tileGroup; // FIXME: list files + selection + current

  @override
  void initState() {
    super.initState();
    _tileGroup = widget.tileGroup;
  }

  @override
  void dispose() {
    super.dispose();
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
              onAddTiles: addTiles,
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
                      child: _tileGroup.files.isEmpty
                          ? Text('Add Tiles (*.png) for this tilegroup..')
                          : ListView(
                              children: [
                                for (TileGroupFile groupFile in _tileGroup.files)
                                  TileGroupListWidget(
                                    groupFile: groupFile, //
                                    selected: widget.groupState.isSelected(groupFile),
                                    onClick: () {
                                      widget.groupState.selectTileGroupFile(groupFile);
                                      setState(() {
                                        // FIXME...
                                        _tileGroup = widget.tileGroup;
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
                      child: Column(
                        children: [
                          Text('aaa'), //
                          Text('bbb'),
                        ],
                      ),
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
      int nextId = _tileGroup.getNextFileId();
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
        setState(() {
          _tileGroup.files.addAll(newFiles);
        });
      }
    }
  }
}
