import 'package:flutter/material.dart';
import 'package:tileseteditor/dialogs/new_project_dialog.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/menubar.dart';

class TileSetEditorApp extends StatefulWidget {
  const TileSetEditorApp({super.key});

  @override
  State<TileSetEditorApp> createState() => _TileSetEditorAppState();
}

class _TileSetEditorAppState extends State<TileSetEditorApp> {
  TileSetProject? project;

  @override
  void initState() {
    super.initState();
    project = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: TileSetEditorMenuBar(project: project, onNewProject: createNewProject),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 200,
                          child: Container(color: Colors.blue, child: Text('Row 1 | Col 1')),
                        ),
                        SizedBox(
                          width: 300,
                          height: 200,
                          child: Container(color: Colors.red, child: Text('Row 1 | Col 2')),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Container(color: Colors.amber, child: Text('Row 2')),
                        ),
                      ],
                    ),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                    Row(children: [Text('1')]),
                    SizedBox(height: 20),
                    Row(children: [Text('2')]),
                    Row(children: [Text('3')]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('hello');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void createNewProject() async {
    TileSetProject? dialogResult = await showDialog<TileSetProject>(
      context: context,
      builder: (BuildContext context) {
        return NewProjectDialog();
      },
    );
    if (dialogResult != null) {
      setState(() {
        project = dialogResult;
      });
    }
  }
}
