class TileReference {
  int tileSetKey;
  int tileIndex;

  TileReference({required this.tileSetKey, required this.tileIndex});

  Map<String, dynamic> toJson() {
    return {
      'tileset': tileSetKey, //
      'index': tileIndex, //
    };
  }

  factory TileReference.fromJson(Map<String, dynamic> json) {
    TileReference result = switch (json) {
      {
        'tileset': int tileSetKey, //
        'index': int tileIndex, //
      } =>
        TileReference(tileSetKey: tileSetKey, tileIndex: tileIndex),
      _ => throw const FormatException('Failed to load TileReference'),
    };
    return result;
  }
}
