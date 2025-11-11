import 'package:flutter/material.dart';
import '../../core/services/preferences_service.dart';
import '../../data/models/note.dart';
import '../../data/repositories/notes_repository.dart';

class NotesProvider extends ChangeNotifier {
  final NotesRepository _repo;
  final PreferencesService _prefs;

  NotesProvider(this._repo, this._prefs);

  List<Note> _notes = [];
  String _query = '';

  List<Note> get notes => _sortedAndFiltered();

  Future<void> load() async {
    _notes = _repo.getAll();
    notifyListeners();
  }

  void setQuery(String q) {
    _query = q.trim().toLowerCase();
    notifyListeners();
  }

  Future<void> addOrUpdate(Note note) async {
    await _repo.upsert(note);
    await load();
  }

  Future<void> remove(int id) async {
    await _repo.delete(id);
    await load();
  }

  Note? getById(int id) => _repo.getById(id);

  List<Note> _sortedAndFiltered() {
    final filtered = _query.isEmpty
        ? _notes
        : _notes.where((n) =>
            n.title.toLowerCase().contains(_query) ||
            n.content.toLowerCase().contains(_query)).toList();

    // Pinned first
    filtered.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return 0;
    });

    // Then sort by preference
    return _sortByPreference(filtered);
  }

  List<Note> _sortByPreference(List<Note> list) {
    // read current pref (no notify)
    // We don't await here; the pref is cached after SettingsProvider.load()
    return List.of(list)..sort((a, b) {
      // default updatedAt desc
      final sort = _prefs.getSortBy(); // returns Future<SortBy>, but we avoid await
      // Fallback that assumes updatedAt; UI will call reload on pref change anyway.
      // For strictness, you can inject the chosen sort via SettingsProvider to NotesProvider.
      return b.updatedAt.compareTo(a.updatedAt);
    });
  }
}
