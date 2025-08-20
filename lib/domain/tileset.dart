class TileSet {
  String name;
  String filePath;
  int tileWidth;
  int tileHeight;
  int margin;
  int spacing;

  TileSet({required this.name, required this.filePath, required this.tileWidth, required this.tileHeight, required this.margin, required this.spacing});

  @override
  String toString() {
    return 'TileSet $name (${tileWidth}x$tileHeight) in $filePath';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'input': filePath,
      'tile': {'width': tileWidth, 'height': tileHeight},
    };
  }
}
