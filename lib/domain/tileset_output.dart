class TileSetOutput {
  int tileWidth;
  int tileHeight;
  int width;
  int height;

  TileSetOutput({required this.tileWidth, required this.tileHeight, required this.width, required this.height});

  Map<String, dynamic> toJson() {
    return {
      'tile': {'width': tileWidth, 'height': tileHeight},
      'size': {'width': width, 'height': height},
    };
  }

  @override
  String toString() {
    return 'Output [${width}x$height] from (${tileWidth}x$tileHeight) tiles';
  }
}
