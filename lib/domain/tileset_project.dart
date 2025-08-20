import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/domain/tileset.dart';

class TileSetProject {
  String? filePath;
  String name;
  String? description;
  int tileWidth;
  int tileHeight;

  List<TileSet> tileSets = [];

  TileSetProject({required this.name, this.description, required this.tileWidth, required this.tileHeight});

  @override
  String toString() {
    return 'Project $name (${tileWidth}x$tileHeight) in $filePath';
  }

  static TileSetProject clone(TileSetProject project) {
    TileSetProject result = TileSetProject(name: project.name, description: project.description, tileWidth: project.tileWidth, tileHeight: project.tileHeight);
    result.filePath = project.filePath;
    return result;
  }

  Map<String, dynamic> toJson(PackageInfo packageInfo) {
    return {
      'name': name,
      'description': description,
      'tile': {'width': tileWidth, 'height': tileHeight},
      'editor': {'name': packageInfo.appName, 'version': packageInfo.version, 'build': packageInfo.buildNumber},
      'sources': toTileSetJson(),
    };
  }

  List<Map<String, dynamic>> toTileSetJson() {
    List<Map<String, dynamic>> result = [];
    for (var tileSet in tileSets) {
      result.add(tileSet.toJson());
    }
    return result;
  }

  factory TileSetProject.fromJson(Map<String, dynamic> json) {
    TileSetProject result = switch (json) {
      {
        'name': String name, //
        'description': String description, //
        'tile': {
          'width': int tileWidth, //
          'height': int tileHeight, //
        }, //
      } =>
        TileSetProject(name: name, description: description, tileWidth: tileWidth, tileHeight: tileHeight),
      _ => throw const FormatException('Failed to load TileSetProject'),
    };
    return result;
  }

  void addTileSet(TileSet tileSet) {
    tileSets.add(tileSet);
  }
}
