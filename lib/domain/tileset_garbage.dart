import 'dart:ui';

import 'package:flutter_randomcolor/flutter_randomcolor.dart';

class TileSetGarbage {
  List<int> indices = [];

  Color color = RandomColor.getColorObject(Options());

  TileSetGarbage();

  Map<String, dynamic> toJson() {
    return {'indices': indices};
  }

  factory TileSetGarbage.fromJson(Map<String, dynamic> json) {
    TileSetGarbage result = TileSetGarbage();
    List<int> indices = json['indices'] != null ? (json['indices'] as List).map((index) => index as int).toList() : [];
    result.indices.addAll(indices);
    return result;
  }

  @override
  String toString() {
    return 'Garbage $indices';
  }
}
