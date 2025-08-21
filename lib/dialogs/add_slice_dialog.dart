import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/widgets/slice_widget.dart';

class AddSliceDialog extends StatefulWidget {
  final TileSet tileSet;
  final List<TileCoord> tiles;

  const AddSliceDialog({super.key, required this.tileSet, required this.tiles});

  @override
  AddSliceDialogState createState() => AddSliceDialogState();
}

class AddSliceDialogState extends State<AddSliceDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  late TileSetSlice _slice;

  @override
  void initState() {
    super.initState();
    int minX = widget.tiles.map((coord) => coord.x).reduce(Math.min);
    int minY = widget.tiles.map((coord) => coord.y).reduce(Math.min);
    int maxX = widget.tiles.map((coord) => coord.x).reduce(Math.max);
    int maxY = widget.tiles.map((coord) => coord.y).reduce(Math.max);
    _slice = TileSetSlice('', minX, minY, maxX - minX + 1, maxY - minY + 1);
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
                              Text("Add tileset slice", style: Theme.of(context).textTheme.headlineSmall),
                              const Align(alignment: Alignment.topRight, child: CloseButton()),
                            ],
                          ),
                          SizedBox(height: space * 2),
                          SliceWidget(slice: _slice, edit: false),
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
                                    Navigator.of(context).pop(_slice);
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
