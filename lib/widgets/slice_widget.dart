import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_slice.dart';
import 'package:tileseteditor/utils/image_utils.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';

class SliceWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSetProject project;
  final TileSet tileSet;
  final TileSetSlice slice;
  final int numberOfNonFreeTiles;

  const SliceWidget({super.key, required this.slice, required this.project, required this.tileSet, required this.numberOfNonFreeTiles});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 250,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: Colors.grey, strokeAlign: 1.0),
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: ImageUtils.cropImage(
                  project.getTileSetPath(tileSet),
                  x: (slice.coord.left - 1) * tileSet.tileSize.widthPx,
                  y: (slice.coord.top - 1) * tileSet.tileSize.heightPx,
                  width: slice.size.width * tileSet.tileSize.widthPx,
                  height: slice.size.height * tileSet.tileSize.heightPx,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 500,
          child: numberOfNonFreeTiles > 0
              ? Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 220, 200, 200),
                              border: BoxBorder.all(color: const Color.fromARGB(255, 104, 14, 14), strokeAlign: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(3.0)),
                            ),
                            child: Text(
                              'The slice cannot be created because it contains tiles that are already part of other named area or have already been discarded.\nNumber of non-free tile(s): $numberOfNonFreeTiles',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    AppDialogNumberField(name: 'ID', initialValue: slice.id, disabled: true),
                    SizedBox(height: space),
                    AppDialogTextField(
                      name: 'Slice name',
                      hint: 'Enter the name of this slice',
                      initialValue: slice.name,
                      validationMessage: 'Please enter the name of the Slice.',
                      onChanged: (String value) {
                        slice.name = value;
                      },
                    ),
                    SizedBox(height: space),
                    AppDialogTextField(name: 'Left x Top', initialValue: '${slice.coord.left} x ${slice.coord.top}', disabled: true),
                    SizedBox(height: space),
                    AppDialogTextField(name: 'Size (width x height)', initialValue: '${slice.size.width} x ${slice.size.height}', disabled: true),
                    SizedBox(height: space),
                    AppDialogTextField(name: 'Tiles (indices)', initialValue: slice.tileIndices.join(','), disabled: true),
                  ],
                ),
        ),
      ],
    );
  }
}
