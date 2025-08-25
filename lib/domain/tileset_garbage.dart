import 'dart:ui';

import 'package:flutter_randomcolor/flutter_randomcolor.dart';

class TileSetGarbage {
  List<int> tileIndices = [];

  Color color = RandomColor.getColorObject(Options());

  TileSetGarbage();

  Map<String, dynamic> toJson() {
    return {'tiles': tileIndices};
  }

  factory TileSetGarbage.fromJson(Map<String, dynamic> json) {
    TileSetGarbage result = TileSetGarbage();
    List<int> tileIndices = json['tiles'] != null ? (json['tiles'] as List).map((index) => index as int).toList() : [];
    if (tileIndices.isNotEmpty) {
      result.tileIndices.addAll(tileIndices);
    }
    return result;
  }

  @override
  String toString() {
    return 'Garbage $tileIndices';
  }
}
