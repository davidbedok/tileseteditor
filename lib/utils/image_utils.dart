import 'dart:async';
import 'dart:io';
import 'dart:ui' as dui;
import 'package:image/image.dart' as imglib;

import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_indexed_coord.dart';
import 'package:tileseteditor/widgets/group_image_widget.dart';

class ImageUtils {
  static Future<dui.Image> getImage(String path) async {
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

  static Image cropImage(String path, {required int x, required int y, required int width, required int height}) {
    imglib.Image? image = imglib.decodePng(File(path).readAsBytesSync());
    imglib.Image croppedImage = imglib.copyCrop(image!, x: x, y: y, width: width, height: height);
    return Image.memory(imglib.encodeJpg(croppedImage), width: 200);
  }

  static List<GroupImageWidget> cropTiles(
    String path,
    List<TileIndexedCoord> coords,
    int tileWidth,
    int tileHeight,
    void Function(bool selected, int tileIndex) onSelection,
    List<int> selectedTiles,
  ) {
    List<GroupImageWidget> result = [];
    imglib.Image? image = imglib.decodePng(File(path).readAsBytesSync());
    for (TileIndexedCoord coord in coords) {
      imglib.Image croppedImage = imglib.copyCrop(
        image!,
        x: (coord.left - 1) * tileWidth,
        y: (coord.top - 1) * tileHeight,
        width: tileWidth,
        height: tileHeight,
      );
      result.add(
        GroupImageWidget(
          tileIndex: coord.index,
          imageBytes: imglib.encodeJpg(croppedImage),
          width: tileWidth.toDouble(),
          height: tileHeight.toDouble(),
          onSelection: onSelection,
          selected: selectedTiles.contains(coord.index),
        ),
      );
    }
    return result;
  }
}
