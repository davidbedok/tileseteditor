import 'package:flutter/material.dart';

enum EditorColor {
  coordText(Colors.black),
  text(Color.fromARGB(255, 14, 110, 199)),

  buttonNormal(Colors.grey),
  buttonDown(Colors.lightGreen),

  externalTile(Color.fromARGB(255, 37, 151, 62)),

  selectedFill(Color.fromARGB(255, 27, 138, 222)),
  selectedExternalFill(Color.fromARGB(255, 112, 228, 30)),

  tile(Color.fromARGB(255, 29, 16, 215)),
  tileHovered(Color.fromARGB(255, 29, 16, 215)),

  garbage(Colors.red),
  garbageSelected(Colors.green),
  garbageHovered(Color.fromARGB(255, 216, 21, 21)),

  group(Color.fromARGB(255, 75, 160, 183)),
  groupHovered(Color.fromARGB(255, 75, 160, 183)), // same as group

  slice(Color.fromARGB(255, 57, 170, 74)),
  sliceText(Color.fromARGB(255, 57, 170, 74)), // same as slice

  file(Color.fromARGB(255, 171, 33, 178)),
  fileHovered(Color.fromARGB(255, 247, 224, 19)),

  ruler(Colors.black);

  final Color color;

  const EditorColor(this.color);
}
