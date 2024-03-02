import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static late SharedPreferences prefs;

  static set isFirstLaunch(bool isFirstLaunch) =>
      prefs.setBool("isFirstLaunch", isFirstLaunch);
  static bool get isFirstLaunch => prefs.getBool("isFirstLaunch") ?? true;

  static set isloggedIn(bool isloggedIn) =>
      prefs.setBool("isloggedIn", isloggedIn);
  static bool get isloggedIn => prefs.getBool("isloggedIn") ?? false;

  // TODO: fix the '' to null
  //* Credentials
  static set userName(String username) => prefs.setString("username", username);
  static String get userName => prefs.getString("username") ?? '';
  static set email(String email) => prefs.setString("email", email);
  static String get email => prefs.getString("email") ?? '';
  static set staffId(String staffId) => prefs.setString("staffId", staffId);
  static String get staffId => prefs.getString("staffId") ?? '';

  static void clear() {
    // prefs.clear();
    PreferenceService.isFirstLaunch = false;
    PreferenceService.isloggedIn = false;
    PreferenceService.userName = "";
    PreferenceService.email = "";
    PreferenceService.staffId = "";
  }

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
}
