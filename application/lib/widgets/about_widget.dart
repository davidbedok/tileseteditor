import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key, required this.packageInfo});

  final PackageInfo packageInfo;

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationName: 'Yet Another TileSet Editor',
      applicationVersion: 'v${packageInfo.version} (build ${packageInfo.buildNumber})',
      applicationIcon: Image(image: AssetImage('assets/images/yate-512.png'), width: 70, height: 70),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
          children: [
            Text('Developer', style: Theme.of(context).textTheme.labelLarge), //
            Text('Dávid Bedők (qwaevisz)'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
          children: [
            Text('Release date', style: Theme.of(context).textTheme.labelLarge), //
            Text('${packageInfo.updateTime}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
          children: [
            Text('Framework', style: Theme.of(context).textTheme.labelLarge), //
            Text('Flutter'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
          children: [
            Text('Graphics', style: Theme.of(context).textTheme.labelLarge), //
            InkWell(
              child: Text('freepik', style: TextStyle(color: const Color.fromARGB(255, 24, 103, 168))),
              onTap: () async {
                if (!await launchUrl(Uri.parse('https://www.flaticon.com/authors/freepik'))) {
                  throw Exception('Could not launch');
                }
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
          children: [
            Text('Licence', style: Theme.of(context).textTheme.labelLarge), //
            Text('GPL-3.0 license'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //
          children: [
            Text('Source', style: Theme.of(context).textTheme.labelLarge), //
            InkWell(
              child: Text('github', style: TextStyle(color: const Color.fromARGB(255, 24, 103, 168))),
              onTap: () async {
                if (!await launchUrl(Uri.parse('https://github.com/davidbedok/tileseteditor'))) {
                  throw Exception('Could not launch');
                }
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.language_outlined), //
            SizedBox(width: 10),
            InkWell(
              child: Text('https://yate.qwaevisz.com', style: TextStyle(color: const Color.fromARGB(255, 24, 103, 168))),
              onTap: () async {
                if (!await launchUrl(Uri.parse('https://yate.qwaevisz.com'))) {
                  throw Exception('Could not launch');
                }
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.email_outlined), //
            SizedBox(width: 10),
            Text('yate@qwaevisz.com'),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Image(image: AssetImage('assets/images/buy-me-a-coffee.png'), width: 25, height: 25),
            SizedBox(width: 10),
            InkWell(
              child: Text('https://buymeacoffee.com/qwaevisz', style: TextStyle(color: const Color.fromARGB(255, 24, 103, 168))),
              onTap: () async {
                if (!await launchUrl(Uri.parse('https://buymeacoffee.com/qwaevisz'))) {
                  throw Exception('Could not launch');
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
