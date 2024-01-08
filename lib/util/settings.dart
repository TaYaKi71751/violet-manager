import 'package:dio/io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static SharedPreferences? prefs;

	static late String releaseChannel;
  
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    releaseChannel = prefs?.getString('target_repository') ?? 'TaYaKi71751/violet-git';
  }

  static Future<void> setReleaseChannel(String value) async {
    releaseChannel = value;
    await prefs?.setString('target_repository', value);
  }
}