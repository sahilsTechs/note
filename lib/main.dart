import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/router/route_names.dart';
import 'core/services/hive_service.dart';
import 'core/services/preferences_service.dart';
import 'data/repositories/notes_repository.dart';
import 'presentation/state/notes_provider.dart';
import 'presentation/state/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService();
    final notesRepo = NotesRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        ChangeNotifierProvider(create: (_) => NotesProvider(notesRepo, prefs)),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appTitle,
            themeMode: settings.themeMode,
            theme: ThemeData(
              colorSchemeSeed: AppColors.primary,
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              colorSchemeSeed: AppColors.primary,
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            initialRoute: RouteNames.home,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
