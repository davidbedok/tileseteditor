import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';

class SliceWidget extends StatelessWidget {
  static final double space = 8.0;

  final TileSetSlice slice;
  final bool edit;

  const SliceWidget({super.key, required this.slice, required this.edit});

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
                initialValue: slice.name,
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (value) {
                  slice.name = value;
                },
                validator: (value) => value!.isEmpty ? 'Please enter the name of the slice' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: space),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Left", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                initialValue: slice.left.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (String value) {
                  slice.left = int.tryParse(value) ?? 0;
                },
                validator: (value) => value!.isEmpty ? 'Please define left' : null,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Top", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                initialValue: slice.top.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (String value) {
                  slice.top = int.tryParse(value) ?? 0;
                },
                validator: (value) => value!.isEmpty ? 'Please define top' : null,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Width", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                initialValue: slice.width.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (String value) {
                  slice.width = int.tryParse(value) ?? 0;
                },
                validator: (value) => value!.isEmpty ? 'Please define width' : null,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Height", style: Theme.of(context).textTheme.bodyMedium)),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                initialValue: slice.height.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (String value) {
                  slice.height = int.tryParse(value) ?? 0;
                },
                validator: (value) => value!.isEmpty ? 'Please define height' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
