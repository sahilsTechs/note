// lib/presentation/screens/settings/settings_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/preferences_service.dart';
import '../../state/settings_provider.dart';

// TODO: change these to your real URLs/IDs
const String kPrivacyUrl = 'https://yourdomain.com/privacy-policy';
const String kIosAppStoreId = '0000000000'; // iOS App Store ID (digits only)

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(title: Text('Appearance')),
          RadioListTile<SavedThemeMode>(
            title: const Text('System'),
            value: SavedThemeMode.system,
            groupValue: _current(settings),
            onChanged: (v) => v != null ? settings.setTheme(v) : null,
          ),
          RadioListTile<SavedThemeMode>(
            title: const Text('Light'),
            value: SavedThemeMode.light,
            groupValue: _current(settings),
            onChanged: (v) => v != null ? settings.setTheme(v) : null,
          ),
          RadioListTile<SavedThemeMode>(
            title: const Text('Dark'),
            value: SavedThemeMode.dark,
            groupValue: _current(settings),
            onChanged: (v) => v != null ? settings.setTheme(v) : null,
          ),

          const Divider(height: 24),
          const ListTile(title: Text('Support')),

          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Share app'),
            subtitle: const Text('Invite friends to try this app'),
            onTap: () => _shareApp(context),
          ),
          ListTile(
            leading: const Icon(Icons.star_rate_outlined),
            title: const Text('Rate us'),
            subtitle: const Text('Leave a rating on the store'),
            onTap: () => _rateApp(context),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            subtitle: Text(kPrivacyUrl),
            onTap: () => _openPrivacy(context),
          ),
        ],
      ),
    );
  }

  SavedThemeMode _current(SettingsProvider s) {
    switch (s.themeMode) {
      case ThemeMode.light:
        return SavedThemeMode.light;
      case ThemeMode.dark:
        return SavedThemeMode.dark;
      case ThemeMode.system:
        return SavedThemeMode.system;
    }
  }

  Future<void> _shareApp(BuildContext context) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final appName = info.appName;
      final packageName = info.packageName;

      final playUrl =
          'https://play.google.com/store/apps/details?id=$packageName';
      final appStoreUrl = 'https://apps.apple.com/app/id$kIosAppStoreId';
      final url = Platform.isAndroid ? playUrl : appStoreUrl;

      final text = 'Try $appName 👇\n$url';
      await Share.share(text, subject: appName);
    } catch (_) {
      _showSnack(context, 'Unable to share right now.');
    }
  }

  Future<void> _rateApp(BuildContext context) async {
    final inAppReview = InAppReview.instance;
    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        return;
      }
      await _openStoreListingFallback(context);
    } catch (_) {
      await _openStoreListingFallback(context);
    }
  }

  Future<void> _openStoreListingFallback(BuildContext context) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final packageName = info.packageName;

      final uri =
          Platform.isAndroid
              ? Uri.parse(
                'https://play.google.com/store/apps/details?id=$packageName',
              )
              : Uri.parse('https://apps.apple.com/app/id$kIosAppStoreId');

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        _showSnack(context, 'Could not open the store.');
      }
    } catch (_) {
      _showSnack(context, 'Could not open the store.');
    }
  }

  Future<void> _openPrivacy(BuildContext context) async {
    final uri = Uri.parse(kPrivacyUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) _showSnack(context, 'Could not open Privacy Policy.');
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
