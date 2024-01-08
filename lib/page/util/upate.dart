import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:violet_manager/util/update.dart';
import 'package:violet_manager/util/version.dart';

class UpdateWidget extends StatefulWidget {
  const UpdateWidget({super.key});

  @override
  State<StatefulWidget> createState() => UpdateWidgetState();
}

class UpdateWidgetState extends State<UpdateWidget> {
  AppVersion? _currentVersion;
  AppVersion? _latestVersion;
  bool? updateAvailable = false;
  String downloadProgress = '';
  String openProgress = '';

  Future<bool> checkUpdate() async {
    if(_currentVersion == null || _latestVersion == null){
      final currentVersion = await VersionManager.getCurrent();
      final latestVersion = await UpdateManager.getLatestAppVersion();
      setState(() {
        _currentVersion = currentVersion;
        _latestVersion = latestVersion;
      });
    }
    if(await VersionManager.compare(
      current: _currentVersion,
      latest: _latestVersion
    )){
      return updateAvailable = true;
    } else {
      return updateAvailable = false;
    }
  }

  Future<void> downloadApk() async {
    if(await checkUpdate()){
      final release = await UpdateManager.getReleaseByTag(_latestVersion?.toString() ?? '');
      final url = release;
      Dio dio = Dio();
      final apkPath = '${(await getTemporaryDirectory()).path}/violet.apk';
      if(await File(apkPath).exists()){
        await File(apkPath).delete(recursive: true);
      }
      try {
        final response = await dio.download(
          '$url',
          '${(await getTemporaryDirectory()).path}/violet.apk',
          onReceiveProgress:(count, total) {
            setState(() {
              downloadProgress = '$count / $total';
            });
          },
        );
      } catch(_){
        setState(() {
          downloadProgress = '$_';
        });
      }
      downloadProgress = '';
    }
  }

  Future<void> openApk() async {
    final apkPath = '${(await getTemporaryDirectory()).path}/violet.apk';
    OpenResult result = await OpenFile.open(apkPath);
    setState(() {
      openProgress = (
        '${result.type}\n'
        '${result.message}'
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    checkUpdate();
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // https://stackoverflow.com/questions/57777737/flutter-give-container-rounded-border
        color: Colors.amber,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Wrap(
        children: [
          if(updateAvailable == true)
          Center(
            child: Text(
              'Update Available',
              style: TextStyle(
                fontSize: 30.0
              ),
            ),
          ),
          if(downloadProgress.isNotEmpty)
          Center(
            child:Text(
              'Download Progress',
              style: TextStyle(
                fontSize: 30.0
              ),
            ),
          ),
          if(downloadProgress.isNotEmpty)
          Center(
            child:Text(
              downloadProgress,
              style: TextStyle(
                fontSize: 20.0
              ),
            ),
          ),
          if(openProgress.isNotEmpty)
          Center(
            child: Text(
              'Open Progress',
              style: TextStyle(
                fontSize: 30.0
              ),
            ),
          ),
          if(openProgress.isNotEmpty)
          Center(
            child: Text(
              openProgress,
              style: TextStyle(
                fontSize: 25.0
              ),
            ),
          ),
          if(updateAvailable == true)
          Center(
            child: FloatingActionButton(
              onPressed: downloadApk,
              tooltip: 'Download APK',
              child: const Icon(Icons.download),
            ),
          ),
          if(updateAvailable == true)
          Center(
            child: FloatingActionButton(
              onPressed: openApk,
              tooltip: 'Open APK',
              child: const Icon(Icons.open_in_new)
            )
          )
        ],
      ),
    );
  }
  
}