import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/state/editor_state.dart';

class CurrentSelection extends StatefulWidget {
  final EditorState editorState;

  const CurrentSelection({super.key, required this.editorState});

  @override
  State<CurrentSelection> createState() => CurrentSelectionState();
}

class CurrentSelectionState extends State<CurrentSelection> {
  String? selectedTileDetails;

  @override
  void initState() {
    super.initState();
    widget.editorState.onSelected = selectTile;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void selectTile(TileInfo tileInfo) {
    setState(() {
      selectedTileDetails = tileInfo.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Current:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
        Text(selectedTileDetails != null ? '$selectedTileDetails' : '-'),
      ],
    );
  }
}
