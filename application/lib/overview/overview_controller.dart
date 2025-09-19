import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/utils/dialog_utils.dart';

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
  late YateItem yateItem;

  @override
  void initState() {
    super.initState();
    widget.outputState.yateItem.subscribeSelection(select);
    yateItem = widget.outputState.yateItem.object;
  }

  @override
  void dispose() {
    super.dispose();
    widget.outputState.yateItem.unsubscribeSelection(select);
  }

  void select(OutputState state, YateItem yateItem) {
    setState(() {
      this.yateItem = yateItem;
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
            onPressed: () async {
              if (await DialogUtils.confirmationDialog(context, 'Warning', 'Are you sure you want to clear the output tileset (remove all elements)?')) {
                widget.outputState.yateItem.unselect();
                widget.outputState.removeAll.invoke();
              }
            },
          ),
          SizedBox(width: 5),
          Visibility(
            visible: yateItem != YateItem.none && yateItem.output != null,
            child: ElevatedButton.icon(
              icon: Icon(Icons.delete),
              label: Text('Remove ${yateItem.getLabel()}'),
              onPressed: () async {
                if (await DialogUtils.confirmationDialog(
                  context,
                  'Warning',
                  'Are you sure you want to remove this ${yateItem.getType()} (${yateItem.getLabel()})?',
                )) {
                  widget.outputState.yateItem.remove();
                  setState(() {
                    yateItem.output = null;
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
