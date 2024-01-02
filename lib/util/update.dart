import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:violet_manager/util/settings.dart';
import 'package:violet_manager/util/version.dart';
import 'package:ota_update/ota_update.dart';

class UpdateManager {
	static Future<AppVersion> getLatestAppVersion() async {
		http.Response res = await http.get(Uri.parse('https://raw.githubusercontent.com/${Settings.releaseChannel}/HEAD/appversion'));
		return AppVersion.fromString(res.body.trim());
	}
	static Future<String> getReleaseByTag(String tag) async {
    final url = 'https://github.com/${Settings.releaseChannel}/releases/download/${tag.replaceAll('+','-')}/app-release.apk';
		return url;
	}
}
