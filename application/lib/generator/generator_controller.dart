import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/output/output_state.dart';
import 'package:tileseteditor/widgets/about_widget.dart';

class GeneratorController extends StatefulWidget {
  final PackageInfo packageInfo;
  final YateProject project;
  final OutputState outputState;
  final void Function() onOverviewPressed;

  const GeneratorController({
    super.key, //
    required this.packageInfo,
    required this.project,
    required this.outputState,
    required this.onOverviewPressed,
  });

  @override
  State<GeneratorController> createState() => GeneratorControllerState();
}

class GeneratorControllerState extends State<GeneratorController> {
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
          ElevatedButton.icon(
            icon: Icon(Icons.space_dashboard_outlined), //
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            label: Text('Overview'),
            onPressed: widget.onOverviewPressed,
          ),
          SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AboutWidget(packageInfo: widget.packageInfo);
                },
              );
            },
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }
}
