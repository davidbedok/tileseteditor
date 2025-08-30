class TileCoord {
  int x;
  int y;

  TileCoord(this.x, this.y);

  Map<String, dynamic> toJson() {
    return {
      'left': x, //
      'top': y, //
    };
  }

  factory TileCoord.fromJson(Map<String, dynamic> json) {
    TileCoord result = switch (json) {
      {
        'left': int x, //
        'top': int y, //
      } =>
        TileCoord(x, y),
      _ => throw const FormatException('Failed to load TileCoord'),
    };
    return result;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || (other is TileCoord && runtimeType == other.runtimeType && x == other.x && y == other.y);

  @override
  int get hashCode => x.hashCode;

  @override
  String toString() {
    return '$x:$y';
  }
}
