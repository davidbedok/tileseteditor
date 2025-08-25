import 'dart:async';
import 'dart:io';
import 'dart:ui' as dui;
import 'package:image/image.dart' as imglib;

import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';

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

  static List<Image> cropTiles(String path, List<TileCoord> coords, int tileWidth, int tileHeight) {
    List<Image> result = [];
    imglib.Image? image = imglib.decodePng(File(path).readAsBytesSync());
    for (TileCoord coord in coords) {
      imglib.Image croppedImage = imglib.copyCrop(image!, x: (coord.x - 1) * tileWidth, y: (coord.y - 1) * tileHeight, width: tileWidth, height: tileHeight);
      result.add(Image.memory(imglib.encodeJpg(croppedImage), width: tileWidth.toDouble(), height: tileHeight.toDouble()));
    }
    return result;
  }
}
