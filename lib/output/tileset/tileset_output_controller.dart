import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/output/tileset/tileset_output_state.dart';

class TileSetOutputController extends StatefulWidget {
  final TileSetProject project;
  final TileSet tileSet;
  final TileSetOutputState outputState;
  final void Function() onSplitterPressed;

  const TileSetOutputController({
    super.key, //
    required this.project,
    required this.tileSet,
    required this.outputState,
    required this.onSplitterPressed,
  });

  @override
  State<TileSetOutputController> createState() => TileSetOutputControllerState();
}

class TileSetOutputControllerState extends State<TileSetOutputController> {
  late YateItem tileSetItem;

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

  void select(TileSetOutputState state, YateItem tileSetItem) {
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
              widget.outputState.tileSetItem.unselect();
              widget.outputState.removeAll.invoke();
            },
          ),
          SizedBox(width: 5),
          Visibility(
            visible: tileSetItem != YateItem.none && tileSetItem.output != null,
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
