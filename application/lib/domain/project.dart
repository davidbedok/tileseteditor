import 'dart:io';
import 'dart:math' as math;

import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/domain/project_item.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:path/path.dart' as path;
import 'package:tileseteditor/domain/output/tileset_output.dart';
import 'package:tileseteditor/domain/items/tilegroup_file.dart';
import 'package:tileseteditor/domain/yate_mapper.dart';

class YateProject {
  static final YateProject none = YateProject(
    version: '1.0',
    name: '', //
    output: TileSetOutput.none,
  );

  String? filePath;
  String version;
  String name;
  String? description;
  String? creator;
  TileSetOutput output;
  List<TileSet> tileSets = [];
  List<TileGroup> tileGroups = [];

  String getDirectory() => path.dirname(filePath!);

  YateProject({
    required this.version, //
    required this.name, //
    this.description,
    this.creator,
    required this.output,
  });

  List<YateProjectItem> getProjectItemsDropDown() {
    List<YateProjectItem> result = [];
    result.add(YateProjectItem.none);
    result.addAll(tileSets);
    result.addAll(tileGroups);
    return result;
  }

  int getNextTileSetId() {
    int max = tileSets.isNotEmpty ? tileSets.map((tileSet) => tileSet.id).reduce(math.max) : -1;
    return max + 1;
  }

  int getNextTileGroupId() {
    int max = tileGroups.isNotEmpty ? tileGroups.map((tileGroup) => tileGroup.id).reduce(math.max) : -1;
    return max + 1;
  }

  int getNextKey() {
    List<int> keys = [];
    keys.addAll(tileSets.map((tileSet) => tileSet.key).toList());
    for (TileGroup tileGroup in tileGroups) {
      keys.addAll(tileGroup.files.map((file) => file.key).toList());
    }
    int max = keys.isNotEmpty ? keys.reduce(math.max) : -1;
    return max + 1;
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
    return path.join(getDirectory(), convertPathIfNeededOnPlatform(filePath));
  }

  String convertPathIfNeededOnPlatform(String filePath) {
    String result = filePath;
    if ( Platform.isMacOS ) {
      result = filePath.replaceAll(RegExp(r'\\'), '/');
    } else if ( Platform.isWindows ) {
      result = filePath.replaceAll(RegExp(r'/'), '\\');
    }
    return result;
  }

  Future<void> loadAllImages() async {
    for (TileSet tileSet in tileSets) {
      await tileSet.loadImage(this);
    }
    for (TileGroup tileGroup in tileGroups) {
      for (TileGroupFile file in tileGroup.files) {
        await file.loadImage(this);
      }
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

  static YateProject clone(YateProject project) {
    TileSetOutput output = TileSetOutput(
      fileName: project.output.fileName,
      tileSize: PixelSize(project.output.tileSize.widthPx, project.output.tileSize.heightPx),
      size: TileRectSize(project.output.size.width, project.output.size.height),
    );
    output.data = project.output.data;
    YateProject result = YateProject(
      version: project.version,
      name: project.name, //
      description: project.description,
      creator: project.creator,
      output: output,
    );
    result.filePath = project.filePath;
    result.tileSets = project.tileSets;
    return result;
  }

  Map<String, dynamic> toJson(PackageInfo packageInfo) {
    tileSets.sort((a, b) => a.id.compareTo(b.id));
    tileGroups.sort((a, b) => a.id.compareTo(b.id));
    return {
      'version': version,
      'name': name,
      'description': description,
      'creator': creator,
      'editor': {'name': packageInfo.appName, 'version': packageInfo.version, 'build': packageInfo.buildNumber},
      'tilesets': YateMapper.itemsToJson(tileSets),
      'tilegroups': YateMapper.itemsToJson(tileGroups),
      'output': output.toJson(tileSets, tileGroups),
    };
  }

  factory YateProject.fromJson(Map<String, dynamic> json) {
    YateProject result = switch (json) {
      {
        'version': String version, //
        'name': String name, //
        'creator': String creator,
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
        YateProject(
          version: version,
          name: name,
          description: json['description'],
          creator: creator,
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
