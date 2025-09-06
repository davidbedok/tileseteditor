class TileReference {
  int key;
  int index;

  TileReference({required this.key, required this.index});

  Map<String, dynamic> toJson() {
    return {
      'key': key, //
      'index': index, //
    };
  }

  factory TileReference.fromJson(Map<String, dynamic> json) {
    TileReference result = switch (json) {
      {
        'key': int key, //
        'index': int index, //
      } =>
        TileReference(key: key, index: index),
      _ => throw const FormatException('Failed to load TileReference'),
    };
    return result;
  }
}
