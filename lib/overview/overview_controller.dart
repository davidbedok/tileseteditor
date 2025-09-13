import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/output/output_state.dart';

class OverviewController extends StatefulWidget {
  final YateProject project;
  final OutputState outputState;

  const OverviewController({
    super.key, //
    required this.project,
    required this.outputState,
  });

  @override
  State<OverviewController> createState() => OverviewControllerState();
}

class OverviewControllerState extends State<OverviewController> {
  late YateItem tileSetItem;

  @override
  void initState() {
    super.initState();
    widget.outputState.yateItem.subscribeSelection(select);
    tileSetItem = widget.outputState.yateItem.object;
  }

  @override
  void dispose() {
    super.dispose();
    widget.outputState.yateItem.unsubscribeSelection(select);
  }

  void select(OutputState state, YateItem tileSetItem) {
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
              widget.outputState.yateItem.unselect();
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
                widget.outputState.yateItem.remove();
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
