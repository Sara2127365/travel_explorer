import 'package:hive_flutter/hive_flutter.dart';

class ThemeLocalDataSource {
  static const String boxName = 'settingsBox';
  static const String themeKey = 'isDark';

  Future<Box> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }

    return await Hive.openBox(boxName);
  }

  Future<bool> getIsDark() async {
    final box = await _getBox();

    return box.get(
      themeKey,
      defaultValue: false,
    );
  }

  Future<void> saveTheme(bool isDark) async {
    final box = await _getBox();

    await box.put(themeKey, isDark);
  }
}