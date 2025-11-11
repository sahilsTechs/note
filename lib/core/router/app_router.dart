import 'package:flutter/material.dart';
import '../../data/models/note.dart';
import '../../presentation/screens/edit_note/edit_note_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteNames.editNote:
        final note = settings.arguments is Note ? settings.arguments as Note? : null;
        return MaterialPageRoute(builder: (_) => EditNoteScreen(existing: note));
      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
