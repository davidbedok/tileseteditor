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
      'tile': {'width': tileWidth, 'height': tileHeight, 'margin': margin, 'spacing': spacing},
    };
  }

  factory TileSet.fromJson(Map<String, dynamic> json) {
    TileSet result = switch (json) {
      {
        'name': String name, //
        'input': String filePath, //
        'tile': {
          'width': int tileWidth, //
          'height': int tileHeight, //
          'margin': int margin,
          'spacing': int spacing,
        }, //
      } =>
        TileSet(name: name, filePath: filePath, tileWidth: tileWidth, tileHeight: tileHeight, margin: margin, spacing: spacing),
      _ => throw const FormatException('Failed to load TileSetProject'),
    };
    return result;
  }
}
