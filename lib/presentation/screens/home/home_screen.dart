// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/cupertino.dart'; // Cupertino icons
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/route_names.dart';
import '../../../data/models/note.dart';
import '../../state/notes_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _searching = false;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<SettingsProvider>().load();
      await context.read<NotesProvider>().load();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NotesProvider>().notes;

    return Scaffold(
      appBar: AppBar(
        title:
            _searching
                ? TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search notes...',
                    border: InputBorder.none,
                  ),
                  onChanged: (v) => context.read<NotesProvider>().setQuery(v),
                )
                : const Text('Note'),
        actions: [
          IconButton(
            icon: Icon(
              _searching ? CupertinoIcons.clear : CupertinoIcons.search,
            ),
            onPressed: () {
              setState(() => _searching = !_searching);
              if (!_searching) {
                _searchCtrl.clear();
                context.read<NotesProvider>().setQuery('');
              }
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.gear),
            onPressed:
                () => Navigator.pushNamed(
                  context,
                  RouteNames.settings,
                ).then((_) => context.read<NotesProvider>().load()),
          ),
        ],
      ),
      body:
          notes.isEmpty
              ? const EmptyState(
                title: 'No notes yet',
                subtitle: 'Tap the + button to create your first note.',
              )
              : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  itemCount: notes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final note = notes[index];

                    return Stack(
                      children: [
                        // Long-press to delete, tap to edit
                        GestureDetector(
                          onLongPress: () => _confirmDelete(note),
                          child: NoteCard(
                            note: note,
                            onTap:
                                () => Navigator.pushNamed(
                                  context,
                                  RouteNames.editNote,
                                  arguments: note,
                                ).then(
                                  (_) => context.read<NotesProvider>().load(),
                                ),
                          ),
                        ),

                        // Top-right delete icon
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Material(
                            color: Colors.black.withOpacity(0.06),
                            shape: const CircleBorder(),
                            child: IconButton(
                              tooltip: 'Delete',
                              iconSize: 18,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(
                                width: 36,
                                height: 36,
                              ),
                              icon: const Icon(
                                CupertinoIcons.delete,
                                color: Colors.redAccent,
                                size: 18,
                              ),
                              onPressed: () => _confirmDelete(note),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, RouteNames.editNote);
          if (context.mounted) {
            await context.read<NotesProvider>().load();
          }
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  Future<void> _confirmDelete(Note note) async {
    final ok =
        await showDialog<bool>(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Delete note?'),
                content: const Text('This action cannot be undone.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
        ) ??
        false;

    if (!ok) return;

    await context.read<NotesProvider>().remove(note.id);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note deleted')));
  }
}
