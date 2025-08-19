import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/widgets/tileset_widget.dart';

class AddTileSetDialog extends StatefulWidget {
  final TileSetProject project;

  const AddTileSetDialog({super.key, required this.project});

  @override
  AddTileSetDialogState createState() => AddTileSetDialogState();
}

class AddTileSetDialogState extends State<AddTileSetDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  late TileSet _tileSet;

  @override
  void initState() {
    super.initState();
    _tileSet = TileSet(name: '', filePath: '', tileWidth: widget.project.tileWidth, tileHeight: widget.project.tileHeight, margin: 0, spacing: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Theme(
        data: Theme.of(context),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(space),
            child: SizedBox(
              width: 800,
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      // boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(3, 3), spreadRadius: 2, blurStyle: BlurStyle.solid)],
                    ),
                    padding: EdgeInsets.all(space),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Add tileset", style: Theme.of(context).textTheme.headlineSmall),
                              const Align(alignment: Alignment.topRight, child: CloseButton()),
                            ],
                          ),
                          SizedBox(height: space * 2),
                          TileSetWidget(tileSet: _tileSet, edit: false),
                          SizedBox(height: space * 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.of(context).pop(_tileSet);
                                  }
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
