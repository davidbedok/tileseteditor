class TileCoord {
  int left;
  int top;

  TileCoord(this.left, this.top);

  Map<String, dynamic> toJson() {
    return {
      'left': left, //
      'top': top, //
    };
  }

  factory TileCoord.fromJson(Map<String, dynamic> json) {
    TileCoord result = switch (json) {
      {
        'left': int left, //
        'top': int top, //
      } =>
        TileCoord(left, top),
      _ => throw const FormatException('Failed to load TileCoord'),
    };
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is TileCoord && runtimeType == other.runtimeType && left == other.left && top == other.top);

  @override
  int get hashCode => left.hashCode;

  @override
  String toString() {
    return '$left:$top';
  }
}
