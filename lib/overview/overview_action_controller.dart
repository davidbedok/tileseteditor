import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/overview/overview_editor_state.dart';

class OverviewActionController extends StatefulWidget {
  final TileSetProject project;
  final OverviewEditorState overviewState;
  final void Function() onSplitterPressed;

  const OverviewActionController({
    super.key, //
    required this.project,
    required this.overviewState,
    required this.onSplitterPressed,
  });

  @override
  State<OverviewActionController> createState() => OverviewActionControllerState();
}

class OverviewActionControllerState extends State<OverviewActionController> {
  TileSetItem? selectedItem;

  @override
  void initState() {
    super.initState();
    widget.overviewState.subscribeOnSelected(select);
    selectedItem = widget.overviewState.selectedItem;
  }

  @override
  void dispose() {
    super.dispose();
    widget.overviewState.unsubscribeOnSelected(select);
  }

  void select(OverviewEditorState state, TileSetItem? tileSetItem) {
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
              widget.overviewState.removeAll();
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
                widget.overviewState.remove();
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
