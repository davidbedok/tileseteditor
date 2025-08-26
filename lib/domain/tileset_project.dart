import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:path/path.dart' as path;

class TileSetProject {
  String? filePath;
  String name;
  String? description;
  int tileWidth;
  int tileHeight;

  List<TileSet> tileSets = [];

  String getDirectory() => path.dirname(filePath!);

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
      'tilesets': toTileSetJson(),
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
    List<Map<String, dynamic>> tileSets = json['tilesets'] != null ? (json['tilesets'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var tileSet in tileSets) {
      result.addTileSet(TileSet.fromJson(tileSet));
    }
    return result;
  }

  void addTileSet(TileSet tileSet) {
    tileSets.add(tileSet);
  }

  String getTileSetFilePathByName(String name) {
    return getTileSetFilePath(tileSets.where((tileSet) => tileSet.name == name).first);
  }

  String getTileSetFilePath(TileSet tileSet) {
    return path.join(getDirectory(), tileSet.filePath);
  }
}
