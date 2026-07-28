import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings.dart';

// Starts the Flutter app and provides ThemeModel to the whole app.
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: const MyApp(),
    ),
  );
}

// Main app widget that controls the theme and app settings.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gets the current theme data.
    final themeModel = Provider.of<ThemeModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ephemeral & App State Example',

      // Changes the app theme based on the selected mode.
      theme: themeModel.isDark ? ThemeData.dark() : ThemeData.light(),

      home: const MyHomePage(),
    );
  }
}

// This page contains the counter and manages local state.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Stores and updates the counter value.
class _MyHomePageState extends State<MyHomePage> {

  // Counter value that belongs only to this page.
  int _counter = 0;

  // Adds 1 to the counter when the button is pressed.
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Gets the theme settings.
    final themeModel = Provider.of<ThemeModel>(context);

    // Resets the counter when the theme changes.
    if (themeModel.themeChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _counter = 0;
        });

        themeModel.resetThemeChanged();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ephemeral & App State Example'),

        actions: [
          IconButton(
            icon: const Icon(Icons.settings),

            // Opens the settings page.
            onPressed: () async {

              final bool? themeChanged = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );

              // Resets counter if the theme was changed.
              if (themeChanged == true) {
                setState(() {
                  _counter = 0;
                });
              }
            },
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            // Displays the current counter value.
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),

      // Button used to increase the counter.
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}