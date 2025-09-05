import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tileseteditor/project/selector.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(minimumSize: Size(1024, 768));

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  windowManager.waitUntilReadyToShow(windowOptions).then((_) async {
    await windowManager.setTitle('Yet Another TileSet Editor');
  });

  runApp(TileSetMaterialApp(packageInfo: packageInfo));
}

class TileSetMaterialApp extends StatelessWidget {
  final PackageInfo packageInfo;

  const TileSetMaterialApp({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: TileSetSelector(packageInfo: packageInfo),
    );
  }
}
