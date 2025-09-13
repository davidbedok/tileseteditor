import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/items/tilegroup_file.dart';

class TileGroupListWidget extends StatefulWidget {
  final TileGroupFile groupFile;
  final bool selected;
  final void Function() onClick;

  const TileGroupListWidget({
    super.key, //
    required this.groupFile,
    required this.selected,
    required this.onClick,
  });

  @override
  State<TileGroupListWidget> createState() => _TileGroupListWidgetState();
}

class _TileGroupListWidgetState extends State<TileGroupListWidget> {
  bool hovered = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            hovered = false;
          });
        },
        child: GestureDetector(
          onTap: widget.onClick,
          child: Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: hovered ? Colors.blueGrey : Colors.transparent),
              borderRadius: BorderRadius.circular(3.0),
              color: hovered
                  ? const Color.fromARGB(83, 179, 187, 62)
                  : widget.selected
                  ? const Color.fromARGB(52, 94, 71, 211)
                  : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RawImage(image: widget.groupFile.image, width: 32, height: 32),
                  SizedBox(width: 5),
                  Flexible(child: Text('(${widget.groupFile.id.toString()}) ${widget.groupFile.filePath}', textAlign: TextAlign.center)), //
                  SizedBox(width: 5),
                  Text('( ${widget.groupFile.size.toString()} )'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
