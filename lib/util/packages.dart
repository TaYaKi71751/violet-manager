import 'dart:io';

class Packages {
  static List<String> getPackageNames(){
    try{
      List<String> rtn = <String>[];
      ProcessResult result = Process.runSync(
        'pm',
        'list packages'.split(' ')
      );
      rtn = result.stdout.toString().split('\n')
        .map((packageName) => packageName.replaceFirst('package:', '').trim()).toList();
      return rtn;
    } catch(e,st){
      print('$e\n$st\n');
      rethrow;
    }
  }
  static List<String> getPackageApkPaths() {
    try {
      List<String> rtn = <String>[];
      ProcessResult result = Process.runSync(
        'pm',
        'list packages -f'.split(' ')
      );
      rtn = result.stdout.toString().split('\n')
        .map((packageName) => packageName.replaceFirst('package:', '').trim()).toList();
      return rtn;
    } catch(e,st){
      print('$e\n$st\n');
      rethrow;
    }
  }

  static String? getPackageApkPath(String packageName){
    try {
      return getPackageApkPaths()
        .where((path) => path.contains('.apk=$packageName'))
        .map((path) => path.replaceAll('.apk=$packageName', '.apk'))
        .firstOrNull;
    } catch(e,st){
      print('$e\n$st\n');
      rethrow;
    }
  }
}