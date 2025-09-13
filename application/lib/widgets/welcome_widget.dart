import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WelcomeWidget extends StatelessWidget {
  final void Function() onNewProject;
  final void Function() onOpenProject;

  const WelcomeWidget({
    super.key, //
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
              ), //
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
            ],
          ),
        ),
      ],
    );
  }
}
