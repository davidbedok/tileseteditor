import 'dart:ui';

import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/domain/yate_mapper.dart';

class TileSetGarbage implements YateMapper {
  List<int> tileIndices = [];

  Color color = RandomColor.getColorObject(Options());

  TileSetGarbage();

  @override
  Map<String, dynamic> toJson() {
    tileIndices.sort();
    return {'indices': tileIndices};
  }

  factory TileSetGarbage.fromJson(Map<String, dynamic> json) {
    TileSetGarbage result = TileSetGarbage();
    result.tileIndices = TileSetItem.tileIndicesFromJson(json);
    return result;
  }

  @override
  String toString() {
    return 'Garbage $tileIndices';
  }
}
