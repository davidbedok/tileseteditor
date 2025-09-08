import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_switch_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';

class TileGroupWidget extends StatefulWidget {
  static final double space = 8.0;

  final TileSetProject project;
  final TileGroup tileGroup;
  final bool edit;

  const TileGroupWidget({super.key, required this.project, required this.tileGroup, required this.edit});

  @override
  State<TileGroupWidget> createState() => _TileGroupWidgetState();
}

class _TileGroupWidgetState extends State<TileGroupWidget> {
  bool active = false;

  @override
  void initState() {
    super.initState();
    active = widget.tileGroup.active;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDialogTextField(
          name: 'Name',
          initialValue: widget.tileGroup.name,
          validationMessage: 'Please enter the name of the TileGroup.',
          onChanged: (String value) {
            widget.tileGroup.name = value;
          },
        ),
        SizedBox(height: TileGroupWidget.space),
        AppDialogSwitchField(
          name: 'Active',
          initialValue: active,
          disabled: false,
          onChanged: (bool value) {
            setState(() {
              active = value;
            });
            widget.tileGroup.active = value;
          },
        ),
        SizedBox(height: TileGroupWidget.space),
        SizedBox(height: TileGroupWidget.space),
        AppDialogNumberField(name: 'Tile width (same as output)', initialValue: widget.tileGroup.tileSize.widthPx, disabled: true),
        AppDialogNumberField(name: 'Tile height (same as output)', initialValue: widget.tileGroup.tileSize.heightPx, disabled: true),
      ],
    );
  }
}
