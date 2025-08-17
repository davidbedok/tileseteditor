import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_project.dart';

class NewProjectDialog extends StatefulWidget {
  const NewProjectDialog({super.key});

  @override
  NewProjectDialogState createState() => NewProjectDialogState();
}

class NewProjectDialogState extends State<NewProjectDialog> {
  final _formKey = GlobalKey<FormState>();

  String? _projectName;
  int? _tileSetWidth;
  int? _tileSetHeight;

  final List<int> _tileSizeOptions = [16, 32];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Theme(
        data: Theme.of(context),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 800,
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6), spreadRadius: 2, blurStyle: BlurStyle.solid)],
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Create new project", style: Theme.of(context).textTheme.headlineSmall),
                              const Align(alignment: Alignment.topRight, child: CloseButton()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text("Name", style: Theme.of(context).textTheme.bodyMedium)),
                              Expanded(
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  onChanged: (value) {
                                    _projectName = value;
                                  },
                                  validator: (value) => value!.isEmpty ? 'Please enter the name of the project' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text("Tile width", style: Theme.of(context).textTheme.bodyMedium)),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _tileSetWidth,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  decoration: const InputDecoration(border: InputBorder.none),
                                  isExpanded: true,
                                  items: _tileSizeOptions.map((int size) {
                                    return DropdownMenuItem<int>(value: size, child: Text(size.toString()));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _tileSetWidth = value;
                                    });
                                  },
                                  validator: (value) => value == null ? 'Please choose tile width' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text("Tile height", style: Theme.of(context).textTheme.bodyMedium)),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _tileSetHeight,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  decoration: const InputDecoration(border: InputBorder.none),
                                  isExpanded: true,
                                  items: _tileSizeOptions.map((int size) {
                                    return DropdownMenuItem<int>(value: size, child: Text(size.toString()));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _tileSetHeight = value;
                                    });
                                  },
                                  validator: (value) => value == null ? 'Please choose tile height' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.of(
                                      context,
                                    ).pop(TileSetProject(name: _projectName!, tileSetWidth: _tileSetWidth!, tileSetHeight: _tileSetHeight!));
                                  }
                                },
                                child: const Text('Create'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
