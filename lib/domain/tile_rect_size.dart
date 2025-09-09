class TileRectSize {
  int width;
  int height;

  int getNumberOfIndices() => width * height;

  TileRectSize(this.width, this.height);

  static List<TileRectSize> options(int numberOfTiles) {
    List<TileRectSize> result = [];
    for (int i = 1; i <= numberOfTiles; i++) {
      if (numberOfTiles % i == 0) {
        result.add(TileRectSize(i, numberOfTiles ~/ i));
      }
    }
    return result;
  }

  String toDropDownValue() {
    return '${width}x$height';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is TileRectSize && runtimeType == other.runtimeType && width == other.width && height == other.height);

  @override
  int get hashCode => width.hashCode;

  @override
  String toString() {
    return '${width} : $height';
  }
}
