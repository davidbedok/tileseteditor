import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;
import 'dart:ui' as dui;

import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/widgets/app_dialog_number_field.dart';
import 'package:tileseteditor/widgets/app_dialog_text_field.dart';

class SliceWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSet tileSet;
  final TileSetSlice slice;
  final bool edit;

  const SliceWidget({super.key, required this.slice, required this.tileSet, required this.edit});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        AppDialogTextField(name: 'Size (width x height)', initialValue: '${slice.width} x ${slice.height}', disabled: true),
        SizedBox(height: space),
        AppDialogTextField(name: 'Tiles (indices)', initialValue: slice.tileIndices.join(','), disabled: true),

        cropImage(tileSet.filePath),
      ],
    );
  }

  Future<dui.Image> getImage(String path) async {
    Completer<ImageInfo> completer = Completer();
    Image img = Image.file(File(path));
    img.image
        .resolve(ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            completer.complete(info);
          }),
        );
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  Image cropImage(String path) {
    imglib.Image? image = imglib.decodePng(File(path).readAsBytesSync());
    imglib.Image croppedImage = imglib.copyCrop(image!, x: (slice.left - 1) * 32, y: (slice.top - 1) * 32, width: slice.width * 32, height: slice.height * 32);
    return Image.memory(imglib.encodeJpg(croppedImage));
  }
}
