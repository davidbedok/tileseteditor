import 'dart:math' as math;

import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:path/path.dart' as path;
import 'package:tileseteditor/domain/tileset_output.dart';

class TileSetProject {
  String? filePath;
  String name;
  String? description;
  TileSetOutput output;

  List<TileSet> tileSets = [];

  String getDirectory() => path.dirname(filePath!);

  TileSetProject({required this.name, this.description, required this.output});

  int getNextTileSetKey() {
    int result = 0;
    int maxTileSetKey = tileSets.isNotEmpty ? tileSets.map((tileSet) => tileSet.key).reduce(math.max) : 0;
    return [result, maxTileSetKey].reduce(math.max) + 1;
  }

  void initOutput() {
    output.init();
    for (var tileSet in tileSets) {
      tileSet.initOutput();
    }
  }

  @override
  String toString() {
    return 'Project $name ($output) in $filePath';
  }

  static TileSetProject clone(TileSetProject project) {
    TileSetOutput output = TileSetOutput(
      tileWidth: project.output.tileWidth,
      tileHeight: project.output.tileHeight,
      width: project.output.width,
      height: project.output.height,
    );
    TileSetProject result = TileSetProject(name: project.name, description: project.description, output: output);
    result.filePath = project.filePath;
    return result;
  }

  Map<String, dynamic> toJson(PackageInfo packageInfo) {
    return {
      'name': name,
      'description': description,
      'editor': {'name': packageInfo.appName, 'version': packageInfo.version, 'build': packageInfo.buildNumber},
      'tilesets': toTileSetJson(),
      'output': output.toJson(tileSets),
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
        'output': {
          'tile': {
            'width': int tileWidth, //
            'height': int tileHeight, //
          }, //
          'size': {
            'width': int width, //
            'height': int height, //
          }, //
        },
      } =>
        TileSetProject(
          name: name,
          description: description,
          output: TileSetOutput(tileWidth: tileWidth, tileHeight: tileHeight, width: width, height: height),
        ),
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
