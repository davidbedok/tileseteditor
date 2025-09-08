class PixelSize {
  int widthPx;
  int heightPx;

  PixelSize(this.widthPx, this.heightPx);

  @override
  String toString() {
    return '${widthPx} x $heightPx';
  }
}
