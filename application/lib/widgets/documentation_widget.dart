import 'package:flutter/material.dart';
import 'package:tileseteditor/widgets/fixed_information_box.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentationWidget extends StatelessWidget {
  static final double space = 8.0;

  const DocumentationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FixedInformationBox(
          infoIcon: false,
          texts: [
            TextSpan(
              text: "Yet Another TileSet Editor is an open-source project for creating tileset images from standalone tiles and from existing tilesets.\n",
            ),
            TextSpan(
              text: '\nKey features:\n',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            WidgetSpan(child: Icon(Icons.circle, size: 10)),
            TextSpan(text: " Scriptable tileset generation (easy to integrate into your CICD)\n"),
            WidgetSpan(child: Icon(Icons.circle, size: 10)),
            TextSpan(text: " Reproducible output (there is no auto tile arrangement, the user can define where to put the tiles)\n"),
            WidgetSpan(child: Icon(Icons.circle, size: 10)),
            TextSpan(text: " Version control support (multiple team members can work on the same project to have a common tileset for your entire game)\n"),
            WidgetSpan(child: Icon(Icons.circle, size: 10)),
            TextSpan(text: " "),
            WidgetSpan(
              child: InkWell(
                child: Text('Tiled', style: TextStyle(color: const Color.fromARGB(255, 24, 103, 168))),
                onTap: () async {
                  if (!await launchUrl(Uri.parse('https://www.mapeditor.org/'))) {
                    throw Exception('Could not launch');
                  }
                },
              ),
            ),
            TextSpan(text: " compatibility (the generated tileset can be used for TileMap creation in Tiled)\n"),
            WidgetSpan(child: Icon(Icons.circle, size: 10)),
            TextSpan(
              text:
                  " Handy and easy-to-use object definition (define slices and group of tiles within an existing tileset in order to always move the related tiles together)\n",
            ),
            WidgetSpan(child: Icon(Icons.circle, size: 10)),
            TextSpan(text: " Trustfulness (each real image manipulation, including cropping, splitting and montage are performed via "),
            WidgetSpan(
              child: InkWell(
                child: Text('ImageMagick', style: TextStyle(color: const Color.fromARGB(255, 24, 103, 168))),
                onTap: () async {
                  if (!await launchUrl(Uri.parse('https://imagemagick.org/'))) {
                    throw Exception('Could not launch');
                  }
                },
              ),
            ),
            TextSpan(text: " commands)\n"),
            TextSpan(
              text: '\nMain components:\n',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            WidgetSpan(child: Icon(Icons.circle, size: 10)),
            TextSpan(
              text:
                  " YATE Project files (*.yate.json): standard json document which refers all the source tiles and tilesets, and describes all the details for generating a new tileset image\n",
            ),
            WidgetSpan(child: Icon(Icons.circle, size: 10)),
            TextSpan(text: " Yet Another TileSet Editor: cross platform desktop application for managing YATE Project files (*.yate.json)\n"),
            WidgetSpan(child: Icon(Icons.circle, size: 10)),
            TextSpan(text: " YATE CLI: Command line interface which loads the YATE Project file and generates the output using ImageMagick commands.\n"),
            TextSpan(
              text: '\nOverview\n\n',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            WidgetSpan(child: Image.asset('assets/images/yate-overview.png')),
            TextSpan(text: "\nFurther details and latest documentation, please visit the project's "),
            WidgetSpan(
              child: InkWell(
                child: Text('GitHub', style: TextStyle(color: const Color.fromARGB(255, 24, 103, 168))),
                onTap: () async {
                  if (!await launchUrl(Uri.parse('https://github.com/davidbedok/tileseteditor/'))) {
                    throw Exception('Could not launch');
                  }
                },
              ),
            ),
            TextSpan(text: " page.\n"),
          ],
        ),

        SizedBox(height: space),
      ],
    );
  }
}
