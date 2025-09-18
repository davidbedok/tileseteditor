import 'package:flutter/material.dart';

enum EditorColor {
  coordText(Colors.black),
  text(Color.fromARGB(255, 14, 110, 199)),

  buttonNormal(Colors.grey),
  buttonDown(Colors.lightGreen),

  selectedFill(Color.fromARGB(255, 27, 138, 222)),
  externalTile(Color.fromARGB(255, 37, 151, 62)),
  selectedExternalFill(Color.fromARGB(255, 112, 228, 30)),

  garbage(Color.fromARGB(255, 216, 21, 21)),
  garbageHovered(Color.fromARGB(255, 216, 21, 21)), // same as garbage
  garbageSelected(Colors.green),

  tile(Color.fromARGB(255, 29, 16, 215)),
  tileHovered(Color.fromARGB(255, 29, 16, 215)), // same as tile

  slice(Color.fromARGB(255, 57, 170, 74)),
  sliceText(Color.fromARGB(255, 57, 170, 74)), // same as slice

  group(Color.fromARGB(255, 75, 160, 183)),
  groupHovered(Color.fromARGB(255, 75, 160, 183)), // same as group

  file(Color.fromARGB(255, 171, 33, 178)),
  fileHovered(Color.fromARGB(255, 171, 33, 178)), // same as file

  ruler(Colors.black),
  grid(Color.fromARGB(161, 150, 142, 142)),
  gridHovered(Color.fromARGB(64, 150, 142, 142));

  final Color color;

  const EditorColor(this.color);
}
