import 'dart:math' as math;

import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/domain/project_item.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:path/path.dart' as path;
import 'package:tileseteditor/domain/output/tileset_output.dart';
import 'package:tileseteditor/domain/tilesetitem/tilegroup_file.dart';
import 'package:tileseteditor/domain/yate_mapper.dart';

class TileSetProject {
  static final TileSetProject none = TileSetProject(
    name: '', //
    description: null,
    output: TileSetOutput.none,
  );

  String? filePath;
  String name;
  String? description;
  TileSetOutput output;
  List<TileSet> tileSets = [];
  List<TileGroup> tileGroups = [];

  String getDirectory() => path.dirname(filePath!);

  TileSetProject({required this.name, this.description, required this.output});

  List<TileSetProjectItem> getProjectItemsDropDown() {
    List<TileSetProjectItem> result = [];
    result.add(TileSetProjectItem.none);
    result.addAll(tileSets);
    result.addAll(tileGroups);
    return result;
  }

  int getNextTileSetId() {
    int max = tileSets.isNotEmpty ? tileSets.map((tileSet) => tileSet.id).reduce(math.max) : 0;
    return max + 1;
  }

  int getNextTileGroupId() {
    int max = tileGroups.isNotEmpty ? tileGroups.map((tileGroup) => tileGroup.id).reduce(math.max) : 0;
    return max + 1;
  }

  int getNextKey() {
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

  int getMaxOutputLeft(int minWidth) {
    return output.getMaxOutputLeft(minWidth, tileSets);
  }

  int getMaxOutputTop(int minHeight) {
    return output.getMaxOutputTop(minHeight, tileSets);
  }

  String getTileSetFilePathByName(String name) {
    return getTileSetPath(tileSets.where((tileSet) => tileSet.name == name).first);
  }

  String getTileSetPath(TileSet tileSet) {
    return buildFilePath(tileSet.filePath);
  }

  String getTileGroupFilePath(TileGroupFile groupFile) {
    return buildFilePath(groupFile.filePath);
  }

  String buildFilePath(String filePath) {
    return path.join(getDirectory(), filePath);
  }

  Future<void> loadTileSetImages() async {
    for (TileSet tileSet in tileSets) {
      await tileSet.loadImage(this);
    }
  }

  void deleteTileSet(TileSet tileSet) {
    tileSets.remove(tileSet);
  }

  void deleteTileGroup(TileGroup tileGroup) {
    tileGroups.remove(tileGroup);
  }

  @override
  String toString() {
    return 'Project $name ($output) in $filePath';
  }

  static TileSetProject clone(TileSetProject project) {
    TileSetOutput output = TileSetOutput(
      fileName: project.output.fileName,
      tileSize: PixelSize(project.output.tileSize.widthPx, project.output.tileSize.heightPx),
      size: TileRectSize(project.output.size.width, project.output.size.height),
    );
    output.data = project.output.data;
    TileSetProject result = TileSetProject(name: project.name, description: project.description, output: output);
    result.filePath = project.filePath;
    result.tileSets = project.tileSets;
    return result;
  }

  Map<String, dynamic> toJson(PackageInfo packageInfo) {
    return {
      'name': name,
      'description': description,
      'editor': {'name': packageInfo.appName, 'version': packageInfo.version, 'build': packageInfo.buildNumber},
      'tilesets': YateMapper.itemsToJson(tileSets),
      'tilegroups': YateMapper.itemsToJson(tileGroups),
      'output': output.toJson(tileSets),
    };
  }

  factory TileSetProject.fromJson(Map<String, dynamic> json) {
    TileSetProject result = switch (json) {
      {
        'name': String name, //
        'description': String description, //
        'output': {
          'file': String fileName, //
          'tile': {
            'width': int tileWidthPx, //
            'height': int tileHeightPx, //
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
          output: TileSetOutput(
            fileName: fileName, //
            tileSize: PixelSize(tileWidthPx, tileHeightPx),
            size: TileRectSize(width, height),
          ),
        ),
      _ => throw const FormatException('Failed to load TileSetProject'),
    };
    result.tileSets = TileSet.itemsFromJson(json);
    result.tileGroups = TileGroup.itemsFromJson(json);
    return result;
  }
}
