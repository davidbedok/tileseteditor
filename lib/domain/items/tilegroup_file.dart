import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/domain/yate_mapper.dart';
import 'package:tileseteditor/utils/image_utils.dart';

class TileGroupFile extends YateItem implements YateMapper {
  int key;
  String filePath;
  PixelSize imageSize;
  TileRectSize size;

  Image? image;

  Color color = RandomColor.getColorObject(Options());

  TileGroupFile({
    required super.id, //
    required this.key,
    required this.filePath,
    required this.imageSize,
    required this.size,
  });

  Future<void> loadImage(TileSetProject project) async {
    image = await ImageUtils.getImage(project.getTileGroupFilePath(this));
  }

  void initTileIndices() {
    tileIndices = List<int>.generate(size.getNumberOfIndices(), (int index) => index++);
  }

  @override
  Color getColor() => color;

  @override
  Color getHoverColor() => EditorColor.tileGroupFileHovered.color;

  @override
  Color getTextColor() => EditorColor.tileGroupFile.color;

  @override
  String getLabel() => filePath;

  @override
  Vector2 getRealPosition(double tileWidth, double tileHeight) => Vector2(0, 0);

  @override
  Vector2 getRealSize(double tileWidth, double tileHeight) => Vector2(size.width * tileWidth, size.height * tileHeight);

  @override
  Map<String, dynamic> toJson() {
    initTileIndices();
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
    result.tileIndices = YateItem.tileIndicesFromJson(json);
    result.output = YateItem.outputFromJson(json);
    return result;
  }
}
