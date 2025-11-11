// lib/data/repositories/notes_repository.dart
import 'package:hive/hive.dart';
import '../../core/constants/app_strings.dart';
import '../models/note.dart';

class NotesRepository {
  Box<Note> get _box => Hive.box<Note>(AppStrings.notesBox);

  List<Note> getAll() {
    return _box.values.toList();
  }

  Future<void> upsert(Note note) async {
    // Use a String key to avoid Hive's 0..0xFFFFFFFF integer key limit
    await _box.put(note.id.toString(), note);
  }

  Future<void> delete(int id) async {
    await _box.delete(id.toString());
  }

  Note? getById(int id) {
    return _box.get(id.toString());
  }
}
