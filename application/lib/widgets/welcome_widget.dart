import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/widgets/information_box.dart';

class WelcomeWidget extends StatelessWidget {
  final PackageInfo packageInfo;
  final void Function() onNewProject;
  final void Function() onOpenProject;

  const WelcomeWidget({
    super.key, //
    required this.packageInfo,
    required this.onNewProject,
    required this.onOpenProject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 20,
          height: 500,
          child: Column(
            children: [
              //
              SizedBox(height: 100),
              Image(image: AssetImage('assets/images/yate-512.png'), width: 70, height: 70),
              Text(
                'Yet Another TileSet Editor',
                style: TextStyle(
                  color: const Color.fromARGB(217, 80, 62, 155), //
                  fontSize: 50,
                ),
              ),

              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'Let\'s ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'create',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          onNewProject.call();
                        },
                    ),
                    TextSpan(text: ' or '),
                    TextSpan(
                      text: 'open',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          onOpenProject.call();
                        },
                    ),
                    TextSpan(text: ' a TileSet Project ('),
                    TextSpan(
                      text: '*.yate.json',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ').'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 450,
                child: InformationBox(
                  texts: [
                    TextSpan(
                      text:
                          " Yet Another TileSet Editor is an open-source project for creating tileset images from standalone tiles and from existing tilesets. This desktop application is primary for creating and editing YATE Project files, and you need the ",
                    ),
                    TextSpan(
                      text: 'yatecli.py',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    TextSpan(text: " (python script) in order to generate the output tileset image."),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'v${packageInfo.version} (build ${packageInfo.buildNumber})',
                style: TextStyle(
                  color: const Color.fromARGB(217, 80, 62, 155), //
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ), //
            ],
          ),
        ),
      ],
    );
  }
}
