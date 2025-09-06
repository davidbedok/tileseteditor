import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';

class TileGroupFile extends TileSetItem {
  int key;
  String filePath;
  PixelSize imageSize;
  TileRectSize size;

  TileGroupFile({
    required super.id, //
    required this.key,
    required this.filePath,
    required this.imageSize,
    required this.size,
  });

  @override
  Color getColor() {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Color getHoverColor() {
    // TODO: implement getHoverColor
    throw UnimplementedError();
  }

  @override
  String getLabel() {
    // TODO: implement getLabel
    throw UnimplementedError();
  }

  @override
  Vector2 getRealPosition(double tileWidth, double tileHeight) {
    // TODO: implement getRealPosition
    throw UnimplementedError();
  }

  @override
  Vector2 getRealSize(double tileWidth, double tileHeight) {
    // TODO: implement getRealSize
    throw UnimplementedError();
  }

  @override
  Color getTextColor() {
    // TODO: implement getTextColor
    throw UnimplementedError();
  }
}
