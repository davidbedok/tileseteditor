import 'dart:ui';

import 'package:flutter_randomcolor/flutter_randomcolor.dart';

class TileSetGroup {
  String name;
  int width;
  int height;
  List<int> indices = [];

  Color color = RandomColor.getColorObject(Options());

  TileSetGroup(this.name, this.width, this.height);

  Map<String, dynamic> toJson() {
    return {
      'name': name, //
      'indices': indices,
      'width': width,
      'height': height,
    };
  }

  factory TileSetGroup.fromJson(Map<String, dynamic> json) {
    TileSetGroup result = switch (json) {
      {
        'name': String name, //
        'width': int width, //
        'height': int height, //
      } =>
        TileSetGroup(name, width, height),
      _ => throw const FormatException('Failed to load TileSetSlice'),
    };
    List<int> indices = json['indices'] != null ? (json['indices'] as List).map((index) => index as int).toList() : [];
    result.indices.addAll(indices);
    return result;
  }

  @override
  String toString() {
    return 'Slice $name (w:$width h:$height)';
  }
}
