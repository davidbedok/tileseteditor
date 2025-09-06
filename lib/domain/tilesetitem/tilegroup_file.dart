import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/domain/yate_mapper.dart';

class TileGroupFile extends TileSetItem implements YateMapper {
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id, //
      'key': key,
      'file': filePath,
      'image': {
        'width': imageSize.widthPx, //
        'height': imageSize.heightPx,
      },
      'width': size.width,
      'height': size.height,
      'indices': tileIndices,
      'output': output?.toJson(),
    };
  }

  static List<TileGroupFile> itemsFromJson(Map<String, dynamic> json) {
    List<TileGroupFile> result = [];
    List<Map<String, dynamic>> groups = json['files'] != null ? (json['files'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var group in groups) {
      result.add(TileGroupFile.fromJson(group));
    }
    return result;
  }

  factory TileGroupFile.fromJson(Map<String, dynamic> json) {
    TileGroupFile result = switch (json) {
      {
        'id': int id,
        'key': int key, //
        'file': String filePath,
        'image': {
          'width': int widthPx, //
          'height': int heightPx,
        },
        'width': int width, //
        'height': int height, //
      } =>
        TileGroupFile(
          id: id, //
          key: key,
          filePath: filePath,
          imageSize: PixelSize(widthPx, heightPx),
          size: TileRectSize(width, height),
        ),
      _ => throw const FormatException('Failed to load TileGroupFile'),
    };
    result.tileIndices = TileSetItem.tileIndicesFromJson(json);
    result.output = TileSetItem.outputFromJson(json);
    return result;
  }
}
