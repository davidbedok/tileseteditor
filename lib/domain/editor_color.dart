import 'package:flutter/material.dart';

enum EditorColor {
  ruler(Colors.black),
  hoverBorder(Color.fromARGB(255, 29, 16, 215)),
  hoverExternalBorder(Color.fromARGB(255, 37, 151, 62)),
  selectedFill(Color.fromARGB(255, 27, 138, 222)),
  selectedExternalFill(Color.fromARGB(255, 112, 228, 30)),
  free(Colors.blue),
  hovered(Color.fromARGB(255, 29, 16, 215)),
  garbage(Colors.red),
  garbageSelected(Colors.green),
  coordText(Colors.black),
  buttonNormal(Colors.grey),
  buttonDown(Colors.lightGreen),
  tile(Color.fromARGB(255, 182, 182, 193)),
  tileHovered(Color.fromARGB(255, 29, 16, 215)),
  tileText(Color.fromARGB(255, 14, 110, 199)),
  tileSetGroup(Color.fromARGB(255, 171, 33, 178)),
  tileSetSlice(Color.fromARGB(255, 247, 224, 19)),
  tileSetTile(Color.fromARGB(255, 0, 0, 0)),
  tileGroupFile(Color.fromARGB(255, 171, 33, 178)),
  tileFreeHovered(Colors.black),
  tileGroupHovered(Color.fromARGB(255, 171, 33, 178)),
  tileSliceHovered(Color.fromARGB(255, 247, 224, 19)),
  tileGroupFileHovered(Color.fromARGB(255, 247, 224, 19)),
  tileGarbageHovered(Color.fromARGB(255, 216, 21, 21));

  final Color color;

  const EditorColor(this.color);
}
