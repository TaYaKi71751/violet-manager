import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:violet_manager/util/update.dart';
import 'package:violet_manager/util/version.dart';

class CurrentVersionWidget extends StatefulWidget {
  const CurrentVersionWidget({super.key});

  @override
  State<CurrentVersionWidget> createState() => CurrentVersionWidgetState();
}

class CurrentVersionWidgetState extends State<CurrentVersionWidget> {
  AppVersion? currentVersion;
  Future<void> init() async {
    if(currentVersion == null){      
      final tmpCurrentVersion = await VersionManager.getCurrent();
      setState((){
        currentVersion ??= tmpCurrentVersion;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // https://stackoverflow.com/questions/57777737/flutter-give-container-rounded-border
        color: Colors.amber,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Center(
        child:Wrap(
          children: [
            Center(
              child: Text(
                'Current Version',
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            Center(
              child: Text(
                currentVersion.toString().split('-').elementAtOrNull(0) ?? '',
                style: TextStyle(fontSize: 45.0),
              ),
            ),
            Center(
              child: Text(
                currentVersion.toString().split('-').elementAtOrNull(1) ?? ''
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LatestVersionWidget extends StatefulWidget {
  const LatestVersionWidget({super.key});

  @override
  State<LatestVersionWidget> createState() => LatestVersionWidgetState();
}

class LatestVersionWidgetState extends State<LatestVersionWidget> {
  AppVersion? latestVersion;
  Future<void> init() async {
    if(latestVersion == null){      
      final tmpLatestVersion = await UpdateManager.getLatestAppVersion();
      setState((){
        latestVersion ??= tmpLatestVersion;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // https://stackoverflow.com/questions/57777737/flutter-give-container-rounded-border
        color: Colors.amber,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Center(
        child:Wrap(
          children: [
            Center(
              child: Text(
                'Latest Version',
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            Center(
              child: Text(
                latestVersion.toString().split('-').elementAtOrNull(0) ?? '',
                style: TextStyle(fontSize: 45.0),
              ),
            ),
            Center(
              child: Text(
                latestVersion.toString().split('-').elementAtOrNull(1) ?? ''
              ),
            )
          ],
        ),
      ),
    );
  }
}
