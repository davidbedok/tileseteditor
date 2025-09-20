import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/utils/dialog_utils.dart';

class TileGroupOutputController extends StatefulWidget {
  final YateProject project;
  final TileGroup tileGroup;
  final OutputState outputState;
  final void Function() onBuilderPressed;

  const TileGroupOutputController({
    super.key, //
    required this.project,
    required this.tileGroup,
    required this.outputState,
    required this.onBuilderPressed,
  });

  @override
  State<TileGroupOutputController> createState() => TileGroupOutputControllerState();
}

class TileGroupOutputControllerState extends State<TileGroupOutputController> {
  late YateItem tileSetItem;

  @override
  void initState() {
    super.initState();
    tileSetItem = widget.outputState.yateItem.object;
    widget.outputState.yateItem.subscribeSelection(select);
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
          ElevatedButton.icon(
            icon: Icon(Icons.edit), //
            label: Text('Builder'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: widget.onBuilderPressed,
          ),
          SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              if (await DialogUtils.confirmationDialog(context, 'Remove all elements', 'Are you sure you want to clear the output tileset?')) {
                widget.outputState.yateItem.unselect();
                widget.outputState.removeAll.invoke();
              }
            },
          ),
          SizedBox(width: 5),
          Visibility(
            visible: tileSetItem != YateItem.none && tileSetItem.output != null,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add_circle_outline),
              label: Text('Remove ${tileSetItem.getLabel()}'),
              onPressed: () async {
                if (await DialogUtils.confirmationDialog(
                  context,
                  'Remove ${tileSetItem.getLabel()}',
                  'Are you sure you want to remove this ${tileSetItem.getType()} from output tileset?',
                )) {
                  widget.outputState.yateItem.remove();
                  setState(() {
                    tileSetItem.output = null;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
