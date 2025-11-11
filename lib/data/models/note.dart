import 'package:hive/hive.dart';

// part 'note.g.dart'; // safe to ignore if not generating

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  final int id; // also used as logical id

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  int colorValue; // background color (int)

  @HiveField(4)
  bool isPinned;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  @HiveField(7)
  int textColorValue; // NEW: text color (int)

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.colorValue,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    required this.textColorValue,
  });

  Note copyWith({
    String? title,
    String? content,
    int? colorValue,
    bool? isPinned,
    DateTime? updatedAt,
    int? textColorValue,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      colorValue: colorValue ?? this.colorValue,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      textColorValue: textColorValue ?? this.textColorValue,
    );
  }
}

// Manual Hive Adapter (no build_runner required)
class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 1;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Note(
      id: fields[0] as int,
      title: fields[1] as String,
      content: fields[2] as String,
      colorValue: fields[3] as int,
      isPinned: fields[4] as bool,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      textColorValue: (fields[7] as int?) ?? 0xFF000000, // default: black
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(8) // total fields now 8
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.colorValue)
      ..writeByte(4)
      ..write(obj.isPinned)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.textColorValue);
  }
}
