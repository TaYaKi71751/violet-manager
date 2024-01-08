import 'dart:io';

import 'package:android_package_installer/android_package_installer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:violet_manager/util/settings.dart';
import 'package:violet_manager/util/update.dart';
import 'package:violet_manager/util/version.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppVersion? _currentVersion;
  AppVersion? _latestVersion;
  int _count = 0;
  int _total = 0;
  bool? _downloading;
  bool? installLock;
  String installStatus = '';
  Future<void> init() async {
    if(_currentVersion == null || _latestVersion == null){
      final currentVersion = await VersionManager.getCurrent();
      final latestVersion = await UpdateManager.getLatestAppVersion();
      setState((){
        _currentVersion ??= currentVersion;
        _latestVersion ??= latestVersion;
      });
    }
  }

  Future<void> downloadApp() async {
    await init();
    final release = await UpdateManager.getReleaseByTag(_latestVersion?.toString() ?? '');
    final url = release;
    Dio dio = Dio();
    setState(() {
      _downloading = true;
    });
    if(await File('${(await getTemporaryDirectory()).path}/violet.apk').exists()){
      await File('${(await getTemporaryDirectory()).path}/violet.apk').delete();
    }
    try {
      final response = await dio.download(
        '$url',
        '${(await getTemporaryDirectory()).path}/violet.apk',
        onReceiveProgress:(count, total) {
          setState(() {
            _count = count;
            _total = total;
          });
        },
      );
    } catch(_){
      print(_);
    }
    finally {
      setState(() {
        _downloading = false;
      });
    }
  }
  Future<void> installApp() async {
    setState(() {
      installStatus = 'Opening APK file';
    });
    final result = await OpenFile.open('${(await getTemporaryDirectory()).path}/violet.apk');
    setState(() {
      installStatus = (
        '${result.type}\n'
        '${result.message}'
      );
    });
  }

  Future<void> _updateApp() async {
    if(installLock == true){
      return;
    }
    if(VersionManager.compare(
      current: _currentVersion,
      latest: _latestVersion,
    )){
      installLock = true;
      await downloadApp();
      await installApp();
    }
  }

  void unlockInstall(){
    installLock = false;
  }

  void setTarget() async {
    Settings.releaseChannel = releaseChannelController.text;
    final currentVersion = await VersionManager.getCurrent();
    final latestVersion = await UpdateManager.getLatestAppVersion();
    setState((){
      _currentVersion = currentVersion;
      _latestVersion = latestVersion;
    });
  }

  final releaseChannelController = TextEditingController(text: 'TaYaKi71751/violet-git');

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Owner/Build_Channel_Repository'
              ),
              controller: releaseChannelController,
            ),
            IconButton(
              onPressed: setTarget,
              icon: const Icon(Icons.save)
            ),
            if(_downloading == true)
            Text(
              'Progress : ${_count} / ${_total}'
            ),
            Text(
              installStatus
            ),
            Text(
              'Current Version'
            ),
            Text(
              _currentVersion.toString().split('-').elementAtOrNull(0) ?? ''
            ),
            Text(
              _currentVersion.toString().split('-').elementAtOrNull(1) ?? ''
            ),
            Text(
              'Latest Version'
            ),
            Text(
              _latestVersion.toString().split('-').elementAtOrNull(0) ?? ''
            ),
            Text(
              _latestVersion.toString().split('-').elementAtOrNull(1) ?? ''
            ),
          ],
        ),
      ),
      floatingActionButton: Wrap(
        children: [
        if(_currentVersion != _latestVersion && installLock != true && _downloading != true)
          FloatingActionButton(
            onPressed: _updateApp,
            tooltip: 'Update',
            child: const Icon(Icons.refresh),
          ),
        if(installLock == true && _downloading != true)
          FloatingActionButton(
            onPressed: unlockInstall,
            tooltip: 'Push When Installed',
            child: const Icon(Icons.verified),
          ),
      ])
    );
  }
}
