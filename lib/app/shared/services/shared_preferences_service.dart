import 'package:shared_preferences/shared_preferences.dart';

/// Shared preferences service class to handle shared preferences
final class SharedPreferencesService {
  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferencesService._();

  static final SharedPreferencesService _instance = SharedPreferencesService._();

  /// Shared preferences instance
  late final SharedPreferences sharedPreferences;

  /// Initialize shared preferences
  Future<void> initShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Set a bool value in shared preferences
  Future<void> setBool({required String key, required bool value}) async {
    await sharedPreferences.setBool(key, value);
  }

  /// Get a bool value from shared preferences
  bool getBool({required String key}) {
    return sharedPreferences.getBool(key) ?? false;
  }
}
