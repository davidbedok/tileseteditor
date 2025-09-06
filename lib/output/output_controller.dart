import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/output/output_state.dart';

class OutputController extends StatefulWidget {
  final TileSetProject project;
  final TileSet tileSet;
  final OutputState outputState;
  final void Function() onSplitterPressed;

  const OutputController({
    super.key, //
    required this.project,
    required this.tileSet,
    required this.outputState,
    required this.onSplitterPressed,
  });

  @override
  State<OutputController> createState() => OutputControllerState();
}

class OutputControllerState extends State<OutputController> {
  late TileSetItem tileSetItem;

  @override
  void initState() {
    super.initState();
    tileSetItem = widget.outputState.tileSetItem.object;
    widget.outputState.tileSetItem.subscribeSelection(select);
  }

  @override
  void dispose() {
    super.dispose();
    widget.outputState.tileSetItem.unsubscribeSelection(select);
  }

  void select(OutputState state, TileSetItem tileSetItem) {
    setState(() {
      this.tileSetItem = tileSetItem;
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
              widget.outputState.tileSetItem.select(TileSetItem.none);
              widget.outputState.removeAll.invoke();
            },
          ),
          SizedBox(width: 5),
          Visibility(
            visible: tileSetItem != TileSetItem.none && tileSetItem.output != null,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add_circle_outline),
              label: Text('Remove ${tileSetItem.getLabel()}'),
              onPressed: () {
                widget.outputState.tileSetItem.remove();
                setState(() {
                  tileSetItem.output = null;
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
