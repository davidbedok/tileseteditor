import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/utils/image_utils.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';

class SliceWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSet tileSet;
  final TileSetSlice slice;

  const SliceWidget({super.key, required this.slice, required this.tileSet});

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
                decoration: BoxDecoration(border: BoxBorder.all(color: Colors.black, strokeAlign: 1.0)),
                child: ImageUtils.cropImage(
                  tileSet.filePath,
                  x: (slice.left - 1) * tileSet.tileWidth,
                  y: (slice.top - 1) * tileSet.tileHeight,
                  width: slice.size.width * tileSet.tileWidth,
                  height: slice.size.height * tileSet.tileHeight,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 400,
          child: Column(
            children: [
              AppDialogNumberField(name: 'Key', initialValue: slice.key, disabled: true),
              AppDialogTextField(
                name: 'Name',
                initialValue: slice.name,
                validationMessage: 'Please enter the name of the Slice.',
                onChanged: (String value) {
                  slice.name = value;
                },
              ),
              SizedBox(height: space),
              AppDialogTextField(name: 'Left x Top', initialValue: '${slice.left} x ${slice.top}', disabled: true),
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
