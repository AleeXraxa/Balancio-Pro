import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCheck {
  static const _onboardingKey = "isFirstTime";

  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? true;
  }

  static Future<void> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, false);
  }
}
