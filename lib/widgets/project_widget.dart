import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_project.dart';

class ProjectWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSetProject project;
  final bool edit;

  final List<int> _tileSizeOptions = List<int>.generate(41, (i) => i + 10);

  ProjectWidget({super.key, required this.project, required this.edit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Name", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: TextFormField(
                initialValue: project.name,
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (value) {
                  project.name = value;
                },
                validator: (value) => value!.isEmpty ? 'Please enter the name of the project' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: space),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Description", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: TextFormField(
                initialValue: project.description,
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (value) {
                  project.description = value;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: space),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Tile width", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: project.tileWidth,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(border: InputBorder.none),
                isExpanded: true,
                items: _tileSizeOptions.map((int size) {
                  return DropdownMenuItem<int>(value: size, child: Text(size.toString()));
                }).toList(),
                onChanged: edit
                    ? null
                    : (value) {
                        project.tileWidth = value!;
                      },
                validator: (value) => value == null ? 'Please choose tile width' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: space),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Tile height", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: project.tileHeight,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(border: InputBorder.none),
                isExpanded: true,
                items: _tileSizeOptions.map((int size) {
                  return DropdownMenuItem<int>(value: size, child: Text(size.toString()));
                }).toList(),
                onChanged: edit
                    ? null
                    : (value) {
                        project.tileHeight = value!;
                      },
                validator: (value) => value == null ? 'Please choose tile height' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
