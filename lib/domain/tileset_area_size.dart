class TileSetAreaSize {
  int width;
  int height;

  TileSetAreaSize(this.width, this.height);

  static List<TileSetAreaSize> options(int numberOfTiles) {
    List<TileSetAreaSize> result = [];
    for (int i = 1; i <= numberOfTiles; i++) {
      if (numberOfTiles % i == 0) {
        result.add(TileSetAreaSize(i, numberOfTiles ~/ i));
      }
    }
    return result;
  }

  String toDropDownValue() {
    return '${width}x$height';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is TileSetAreaSize && runtimeType == other.runtimeType && width == other.width && height == other.height);

  @override
  int get hashCode => width.hashCode;

  @override
  String toString() {
    return '${width}x:$height';
  }
}
