import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/widgets/project_widget.dart';

class EditProjectDialog extends StatefulWidget {
  final TileSetProject project;

  const EditProjectDialog({super.key, required this.project});

  @override
  EditProjectDialogState createState() => EditProjectDialogState();
}

class EditProjectDialogState extends State<EditProjectDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Theme(
        data: Theme.of(context),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(space),
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
                    padding: EdgeInsets.all(space),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Edit project", style: Theme.of(context).textTheme.headlineSmall),
                              const Align(alignment: Alignment.topRight, child: CloseButton()),
                            ],
                          ),
                          SizedBox(height: space * 2),
                          ProjectWidget(project: widget.project, edit: true),
                          SizedBox(height: space * 2),
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
                                    Navigator.of(context).pop(widget.project);
                                  }
                                },
                                child: const Text('Modify'),
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
