import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/output/tilegroup/tilegroup_output_state.dart';

class TileGroupOutputController extends StatefulWidget {
  final TileSetProject project;
  final TileGroup tileGroup;
  final TileGroupOutputState outputState;
  final void Function() onSplitterPressed;

  const TileGroupOutputController({
    super.key, //
    required this.project,
    required this.tileGroup,
    required this.outputState,
    required this.onSplitterPressed,
  });

  @override
  State<TileGroupOutputController> createState() => TileGroupOutputControllerState();
}

class TileGroupOutputControllerState extends State<TileGroupOutputController> {
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

  void select(TileGroupOutputState state, TileSetItem tileSetItem) {
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
