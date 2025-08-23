class TileCoord {
  int x;
  int y;

  TileCoord(this.x, this.y);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is TileCoord && runtimeType == other.runtimeType && x == other.x && y == other.y);

  @override
  int get hashCode => x.hashCode;

  @override
  String toString() {
    return '$x:$y';
  }
}
