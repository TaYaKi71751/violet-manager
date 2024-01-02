import 'dart:io';

import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:violet_manager/util/packages.dart';
class AppVersion {
	String? hash;
	String? dot;

	static AppVersion fromString(String versionString){
		AppVersion rtn = AppVersion();
		if(versionString.contains('+')) {
			final first = versionString
				.split('+')
				.firstOrNull;
			final last = versionString
				.split('+')
				.lastOrNull;
			if(first?.contains('.') ?? false){
				rtn.dot ??= first;
			}
			if(last?.contains('.') ?? false){
				rtn.dot ??= last;
			}
			rtn.dot ??= '0.0.0';
			if(!(first?.contains('.') ?? true)){
				rtn.hash ??= first;
			}
			if(!(last?.contains('.') ?? true)){
				rtn.hash ??= last;
			}
			rtn.hash ??= '0';
		}
		return rtn;
	}
	static AppVersion fromTagString(String versionString){
		AppVersion rtn = AppVersion();
		if(versionString.contains('-')) {
			final first = versionString
				.split('-')
				.firstOrNull;
			final last = versionString
				.split('-')
				.lastOrNull;
			if(first?.contains('.') ?? false){
				rtn.dot ??= first;
			}
			if(last?.contains('.') ?? false){
				rtn.dot ??= last;
			}
			rtn.dot ??= '0.0.0';
			if(!(first?.contains('.') ?? true)){
				rtn.hash ??= first;
			}
			if(!(last?.contains('.') ?? true)){
				rtn.hash ??= last;
			}
			rtn.hash ??= '0';
		}
		return rtn;
	}

	@override
   String toString(){
		return '$dot-$hash';
	}

	String toTagString(){
		return toString().replaceAll('+', '-');
	}
}
class VersionManager {
	static bool compare({
		AppVersion? current,
		AppVersion? latest,
	}){
		/* return false when at least one is null */ 
		if(current == null || latest == null) return false;
		/* return compare at else */
		return current.toString() != latest.toString();
	}

	static Future<AppVersion> getCurrent() async {
    String? packagePath;
    try {
      packagePath = Packages.getPackageApkPath('xyz.project.violet');
    } catch(_){}
    if(packagePath == null){
      return AppVersion.fromString('0.0.0+0');
    }
    if(!(await Directory('${(await getTemporaryDirectory()).path}').exists())){
      await Directory('${(await getTemporaryDirectory()).path}').create(recursive: true);
    }
    ProcessResult result = Process.runSync(
      'rm',
      ['-rf','${(await getTemporaryDirectory()).path}/apk-extract']
    );
    result = Process.runSync(
      'mkdir',
      ['-p','${(await getTemporaryDirectory()).path}/apk-extract']
    );
    result = Process.runSync(
      'unzip',
      ['$packagePath','-d','${(await getTemporaryDirectory()).path}/apk-extract']
    );
    result = Process.runSync(
      'cat', ['${(await getTemporaryDirectory()).path}/apk-extract/assets/flutter_assets/assets/HEAD']);
    String? versionCode = result.stdout?.replaceAll('\n','');
    versionCode = (versionCode?.isEmpty ?? true) ? '+0' : '+$versionCode';
		List<AppInfo> apps = await InstalledApps.getInstalledApps(true);
    final p = apps
      .where((app) => app.packageName?.contains('xyz.project.violet') ?? false)
      .firstOrNull;
    if(p == null){
      return AppVersion.fromString('0.0.0+0');
    }
    return AppVersion.fromString('${p.versionName}+${versionCode}');
	}

}