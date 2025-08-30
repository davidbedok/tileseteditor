class TileReference {
  int tileSetKey;
  int tileIndex;

  TileReference({required this.tileSetKey, required this.tileIndex});

  Map<String, dynamic> toJson() {
    return {
      'tileSet': tileSetKey, //
      'tile': tileIndex, //
    };
  }

  factory TileReference.fromJson(Map<String, dynamic> json) {
    TileReference result = switch (json) {
      {
        'tileSet': int tileSetKey, //
        'tile': int tileIndex, //
      } =>
        TileReference(tileSetKey: tileSetKey, tileIndex: tileIndex),
      _ => throw const FormatException('Failed to load TileReference'),
    };
    return result;
  }
}
