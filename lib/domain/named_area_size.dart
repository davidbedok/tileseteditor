class NamedAreaSize {
  int width;
  int height;

  NamedAreaSize(this.width, this.height);

  static List<NamedAreaSize> options(int numberOfTiles) {
    List<NamedAreaSize> result = [];
    for (int i = 1; i <= numberOfTiles; i++) {
      if (numberOfTiles % i == 0) {
        result.add(NamedAreaSize(i, numberOfTiles ~/ i));
      }
    }
    return result;
  }

  String toDropDownValue() {
    return '${width}x$height';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is NamedAreaSize && runtimeType == other.runtimeType && width == other.width && height == other.height);

  @override
  int get hashCode => width.hashCode;

  @override
  String toString() {
    return '${width}x:$height';
  }
}
