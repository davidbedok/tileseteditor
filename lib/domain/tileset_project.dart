class TileSetProject {
  String name;
  int tileSetWidth;
  int tileSetHeight;

  TileSetProject({required this.name, required this.tileSetWidth, required this.tileSetHeight});

  @override
  String toString() {
    return 'Project $name (${tileSetWidth}x$tileSetHeight)';
  }
}
