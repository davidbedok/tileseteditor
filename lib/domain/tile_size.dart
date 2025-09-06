class TileSize {
  int widthPx;
  int heightPx;

  TileSize(this.widthPx, this.heightPx);

  @override
  String toString() {
    return '${widthPx}x:$heightPx';
  }
}
