import 'package:flutter/material.dart';
import '../../core/services/preferences_service.dart';

class SettingsProvider extends ChangeNotifier {
  final PreferencesService _prefs;
  SavedThemeMode _savedThemeMode = SavedThemeMode.system;
  SortBy _sortBy = SortBy.updatedAt;

  SettingsProvider(this._prefs);

  ThemeMode get themeMode => switch (_savedThemeMode) {
    SavedThemeMode.system => ThemeMode.system,
    SavedThemeMode.light  => ThemeMode.light,
    SavedThemeMode.dark   => ThemeMode.dark,
  };

  SortBy get sortBy => _sortBy;

  Future<void> load() async {
    _savedThemeMode = await _prefs.getThemeMode();
    _sortBy = await _prefs.getSortBy();
    notifyListeners();
  }

  Future<void> setTheme(SavedThemeMode mode) async {
    _savedThemeMode = mode;
    await _prefs.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> setSort(SortBy sort) async {
    _sortBy = sort;
    await _prefs.setSortBy(sort);
    notifyListeners();
  }
}
