import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/note.dart';
import '../constants/app_strings.dart';

class HiveService {
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);

    if (!Hive.isAdapterRegistered(NoteAdapter().typeId)) {
      Hive.registerAdapter(NoteAdapter());
    }

    if (!Hive.isBoxOpen(AppStrings.notesBox)) {
      await Hive.openBox<Note>(AppStrings.notesBox);
    }
  }
}
