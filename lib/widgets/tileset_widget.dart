import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tileseteditor/domain/tileset.dart';

class TileSetWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSet tileSet;
  final bool edit;

  final List<int> _tileSizeOptions = List<int>.generate(41, (i) => i + 10);

  final sourceController = TextEditingController();

  TileSetWidget({super.key, required this.tileSet, required this.edit});

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
                initialValue: tileSet.name,
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (value) {
                  tileSet.name = value;
                },
                validator: (value) => value!.isEmpty ? 'Please enter the name of the tileset' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: space),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Source", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: TextFormField(
                controller: sourceController,
                style: Theme.of(context).textTheme.bodyMedium,
                readOnly: true,
                validator: (value) => value!.isEmpty ? 'Please select a tileset image' : null,
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  browseTileSet();
                },
                child: const Text('Browse'),
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
                value: tileSet.tileWidth,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(border: InputBorder.none),
                isExpanded: true,
                items: _tileSizeOptions.map((int size) {
                  return DropdownMenuItem<int>(value: size, child: Text(size.toString()));
                }).toList(),
                onChanged: edit
                    ? null
                    : (value) {
                        tileSet.tileWidth = value!;
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
                value: tileSet.tileHeight,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(border: InputBorder.none),
                isExpanded: true,
                items: _tileSizeOptions.map((int size) {
                  return DropdownMenuItem<int>(value: size, child: Text(size.toString()));
                }).toList(),
                onChanged: edit
                    ? null
                    : (value) {
                        tileSet.tileHeight = value!;
                      },
                validator: (value) => value == null ? 'Please choose tile height' : null,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Margin", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                initialValue: tileSet.margin.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (String value) {
                  tileSet.margin = int.tryParse(value) ?? 0;
                },
                validator: (value) => value!.isEmpty ? 'Please define tileset margin' : null,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Spacing", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                initialValue: tileSet.spacing.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (String value) {
                  tileSet.spacing = int.tryParse(value) ?? 0;
                },
                validator: (value) => value!.isEmpty ? 'Please define tileset spacing' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void browseTileSet() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['png'],
      dialogTitle: 'Open TileSet',
      type: FileType.image,
    );
    if (filePickerResult != null) {
      sourceController.text = filePickerResult.files.single.path!;
      tileSet.filePath = sourceController.text;
    }
  }
}
