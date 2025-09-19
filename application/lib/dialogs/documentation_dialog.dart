import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/items/tileset_group.dart';
import 'package:tileseteditor/widgets/app_dialog_widget.dart';
import 'package:tileseteditor/widgets/documentation_widget.dart';

class DocumentationDialog extends StatefulWidget {
  const DocumentationDialog({super.key});

  @override
  DocumentationDialogState createState() => DocumentationDialogState();
}

class DocumentationDialogState extends State<DocumentationDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  late TileSetGroup _group;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogWidget(
      formKey: _formKey,
      title: 'User Guide',
      width: 800,
      enabled: false,
      actionButton: 'OK',
      onAction: () {
        Navigator.of(context).pop(_group);
      },
      children: [DocumentationWidget()],
    );
  }
}
