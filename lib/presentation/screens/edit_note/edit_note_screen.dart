import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/note.dart';
import '../../state/notes_provider.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/color_picker_row.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? existing;
  const EditNoteScreen({super.key, this.existing});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  late int _bgColorValue;
  late int _textColorValue;
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.existing?.content ?? '');
    _bgColorValue = widget.existing?.colorValue ?? AppColors.noteColors.first.value;
    _textColorValue = widget.existing?.textColorValue ?? 0xFF000000; // black
    _isPinned = widget.existing?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final now = DateTime.now();
    final note = widget.existing == null
        ? Note(
            id: now.microsecondsSinceEpoch,
            title: _titleCtrl.text.trim(),
            content: _contentCtrl.text.trim(),
            colorValue: _bgColorValue,
            textColorValue: _textColorValue,
            isPinned: _isPinned,
            createdAt: now,
            updatedAt: now,
          )
        : widget.existing!.copyWith(
            title: _titleCtrl.text.trim(),
            content: _contentCtrl.text.trim(),
            colorValue: _bgColorValue,
            textColorValue: _textColorValue,
            isPinned: _isPinned,
            updatedAt: now,
          );

    await context.read<NotesProvider>().addOrUpdate(note);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bg = Color(_bgColorValue);
    final textColor = Color(_textColorValue);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            tooltip: _isPinned ? 'Unpin' : 'Pin',
            icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined, color:  AppColors.bgLight),
            onPressed: () => setState(() => _isPinned = !_isPinned),
          ),
          IconButton(
            tooltip: 'Save',
            icon: Icon(Icons.check, color: AppColors.bgLight),
            onPressed: _save,
          ),
        ],
      ),
      body: Container(
        color: bg,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                AppTextField(
                  controller: _titleCtrl,
                  hint: 'Title',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _contentCtrl,
                  hint: 'Start typing...',
                  maxLines: 20,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: textColor,
                      ),
                ),
                const SizedBox(height: 16),
                Text('Background', style: TextStyle(color: textColor)),
                const SizedBox(height: 8),
                ColorPickerRow(
                  selectedColorValue: _bgColorValue,
                  onChanged: (val) => setState(() => _bgColorValue = val),
                  palette: AppColors.noteColors,
                ),
                const SizedBox(height: 16),
                Text('Text Color', style: TextStyle(color: textColor)),
                const SizedBox(height: 8),
                ColorPickerRow(
                  selectedColorValue: _textColorValue,
                  onChanged: (val) => setState(() => _textColorValue = val),
                  palette: AppColors.textColors,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
