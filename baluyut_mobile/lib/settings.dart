import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Stores the app theme settings.
class ThemeModel with ChangeNotifier {

  // Saves the current theme mode.
  bool _isDark = false;

  // Gets the current theme mode.
  bool get isDark => _isDark;


  // Checks if the theme was changed.
  bool _themeChanged = false;

  // Gets the theme change status.
  bool get themeChanged => _themeChanged;


  // Changes between light mode and dark mode.
  void toggleTheme() {
    _isDark = !_isDark;
    _themeChanged = true;

    // Updates widgets that use this data.
    notifyListeners();
  }


  // Resets the theme change status.
  void resetThemeChanged() {
    _themeChanged = false;
  }
}


// Page where users can change app settings.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16.0),

        children: [

          // Updates the switch when the theme changes.
          Consumer<ThemeModel>(
            builder: (context, themeModel, child) {

              return SwitchListTile(

                // Name of the setting.
                title: const Text('Dark Mode'),

                // Description of the setting.
                subtitle: const Text(
                  'Toggle between Light and Dark theme',
                ),

                // Shows the current theme status.
                value: themeModel.isDark,

                // Changes the theme when switched.
                onChanged: (_) {
                  themeModel.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}