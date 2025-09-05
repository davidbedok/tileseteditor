import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/overview/overview_state.dart';

class OverviewController extends StatefulWidget {
  final TileSetProject project;
  final OverviewState overviewState;

  const OverviewController({
    super.key, //
    required this.project,
    required this.overviewState,
  });

  @override
  State<OverviewController> createState() => OverviewControllerState();
}

class OverviewControllerState extends State<OverviewController> {
  late TileSetItem tileSetItem;

  @override
  void initState() {
    super.initState();
    widget.overviewState.tileSetItem.subscribeSelection(select);
    tileSetItem = widget.overviewState.tileSetItem.object;
  }

  @override
  void dispose() {
    super.dispose();
    widget.overviewState.tileSetItem.unsubscribeSelection(select);
  }

  void select(OverviewState state, TileSetItem tileSetItem) {
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
              widget.overviewState.tileSetItem.select(TileSetItem.none);
              widget.overviewState.removeAll.invoke();
            },
          ),
          SizedBox(width: 5),
          Visibility(
            visible: tileSetItem != TileSetItem.none && tileSetItem.output != null,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add_circle_outline),
              label: Text('Remove ${tileSetItem.getButtonLabel()}'),
              onPressed: () {
                widget.overviewState.tileSetItem.remove();
                setState(() {
                  tileSetItem.output = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
