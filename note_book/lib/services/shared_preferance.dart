import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceServices {
  static SharedPreferences? sfs;

  static void oninit() async {
    sfs = await SharedPreferences.getInstance();
  }

  static void setdata({required String key, required dynamic value}) async {
    if (sfs is int) {
      await sfs!.setInt(key, value);
    } else if (sfs is String) {
      await sfs!.setString(key, value);
    } else if (sfs is double) {
      await sfs!.setDouble(key, value);
    } else if (sfs is bool) {
      await sfs!.setBool(key, value);
    }
  }

  static int getIntData({required String key}) {
    return sfs!.getInt(key) ?? 0;
  }

  static double getDoubleData({required String key}) {
    return sfs!.getDouble(key) ?? 0.0;
  }

  static bool getbool({required String key}) {
    return sfs!.getBool(key) ?? false;
  }

  static String getString({required String key}) {
    return sfs!.getString(key) ?? "";
  }
}
