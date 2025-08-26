class TileUtils {
  static void swapTiles(List<int> tileIndices, int leftTileIndex, int rightTileIndex) {
    int leftIndex = tileIndices.indexOf(leftTileIndex);
    int rightIndex = tileIndices.indexOf(rightTileIndex);
    int tmpTileIndex = tileIndices[leftIndex];
    tileIndices[leftIndex] = tileIndices[rightIndex];
    tileIndices[rightIndex] = tmpTileIndex;
  }
}
