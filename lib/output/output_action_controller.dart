import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';

class OutputActionController extends StatefulWidget {
  final TileSetProject project;
  final TileSet tileSet;
  final void Function() onSplitterPressed;

  const OutputActionController({
    super.key, //
    required this.project,
    required this.tileSet,
    required this.onSplitterPressed,
  });

  @override
  State<OutputActionController> createState() => OutputActionControllerState();
}

class TileSetImage {}

class OutputActionControllerState extends State<OutputActionController> {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [ElevatedButton.icon(icon: Icon(Icons.edit), label: Text('Splitter'), onPressed: widget.onSplitterPressed)],
      ),
    );
  }
}
