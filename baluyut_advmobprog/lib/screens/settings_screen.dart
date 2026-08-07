import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/theme_provider.dart';

// Page where users can change app settings.
// Enhancement 3: The dark/light switch now lives on its own screen.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Rebuilds just this tile when the theme changes.
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle between Light and Dark theme'),
                value: themeProvider.isDark,
                onChanged: (_) => themeProvider.toggleTheme(),
              );
            },
          ),
        ],
      ),
    );
  }
}
