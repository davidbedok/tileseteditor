import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/output/state/output_editor_state.dart';

class OutputActionController extends StatefulWidget {
  final TileSetProject project;
  final TileSet tileSet;
  final OutputEditorState outputState;
  final void Function() onSplitterPressed;

  const OutputActionController({
    super.key, //
    required this.project,
    required this.tileSet,
    required this.outputState,
    required this.onSplitterPressed,
  });

  @override
  State<OutputActionController> createState() => OutputActionControllerState();
}

class OutputActionControllerState extends State<OutputActionController> {
  TileSetItem? selectedItem;

  @override
  void initState() {
    super.initState();
    widget.outputState.subscribeOnSelected(select);
    selectedItem = widget.outputState.selectedItem;
  }

  @override
  void dispose() {
    super.dispose();
    widget.outputState.unsubscribeOnSelected(select);
  }

  void select(OutputEditorState state, TileSetItem? tileSetItem) {
    setState(() {
      selectedItem = tileSetItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              widget.outputState.removeAll();
              setState(() {
                selectedItem = null;
              });
            },
          ),
          SizedBox(width: 5),
          Visibility(
            visible: selectedItem != null && selectedItem!.output != null,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add_circle_outline),
              label: Text('Remove ${selectedItem != null ? selectedItem!.getButtonLabel() : ''}'),
              onPressed: () {
                widget.outputState.remove();
                setState(() {
                  if (selectedItem != null) {
                    selectedItem!.output = null;
                  }
                });
              },
            ),
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.edit), //
            label: Text('Splitter'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: widget.onSplitterPressed,
          ),
        ],
      ),
    );
  }
}
