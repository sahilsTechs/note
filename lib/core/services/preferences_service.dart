import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_strings.dart';

enum SortBy { updatedAt, createdAt, title }
enum SavedThemeMode { system, light, dark }

class PreferencesService {
  Future<SavedThemeMode> getThemeMode() async {
    final sp = await SharedPreferences.getInstance();
    final value = sp.getString(AppStrings.prefThemeMode) ?? 'system';
    switch (value) {
      case 'light': return SavedThemeMode.light;
      case 'dark': return SavedThemeMode.dark;
      default: return SavedThemeMode.system;
    }
  }

  Future<void> setThemeMode(SavedThemeMode mode) async {
    final sp = await SharedPreferences.getInstance();
    final value = switch (mode) {
      SavedThemeMode.system => 'system',
      SavedThemeMode.light  => 'light',
      SavedThemeMode.dark   => 'dark',
    };
    await sp.setString(AppStrings.prefThemeMode, value);
  }

  Future<SortBy> getSortBy() async {
    final sp = await SharedPreferences.getInstance();
    final value = sp.getString(AppStrings.prefSort) ?? 'updatedAt';
    switch (value) {
      case 'createdAt': return SortBy.createdAt;
      case 'title': return SortBy.title;
      default: return SortBy.updatedAt;
    }
  }

  Future<void> setSortBy(SortBy sort) async {
    final sp = await SharedPreferences.getInstance();
    final value = switch (sort) {
      SortBy.updatedAt => 'updatedAt',
      SortBy.createdAt => 'createdAt',
      SortBy.title     => 'title',
    };
    await sp.setString(AppStrings.prefSort, value);
  }
}
