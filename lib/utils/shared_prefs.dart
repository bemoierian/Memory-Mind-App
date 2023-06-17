import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!; //we are sure that _prefsInstance is not null because we initialized it in the beginning of the app in init method
  }

  static String getString(String key, [String defValue = '']) {
    return _prefsInstance?.getString(key) ?? defValue;
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    var prefs = await _instance;
    return prefs.getBool(key) ?? false;
  }

  static Future<bool> setStringList(String key, List<String> list) async {
    var prefs = await _instance;
    return prefs.setStringList(key, list);
  }

  static getStringList(String key) {
    return _prefsInstance?.getStringList(key) ?? [];
  }
}
