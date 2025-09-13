import 'dart:typed_data';

import 'package:flutter/material.dart';

class GroupImageWidget extends StatelessWidget {
  final int tileIndex;
  final Uint8List imageBytes;
  final double width;
  final double height;
  final bool selected;

  final void Function(bool selected, int tileIndex) onSelection;

  const GroupImageWidget({
    super.key,
    required this.tileIndex,
    required this.imageBytes,
    required this.width,
    required this.height,
    required this.onSelection,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: selected ? BoxDecoration(border: BoxBorder.all(color: Colors.blue, width: 0.0)) : null,
        child: Image.memory(imageBytes, width: width, height: height),
      ),
      onTap: () {
        onSelection.call(selected, tileIndex);
      },
    );
  }
}
