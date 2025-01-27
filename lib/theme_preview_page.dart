import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_theme.dart';

class ThemePreviewPage extends StatefulWidget {
  @override
  _ThemePreviewPageState createState() => _ThemePreviewPageState();
}

class _ThemePreviewPageState extends State<ThemePreviewPage> {
  bool isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Theme Preview'),
          actions: [
            Switch(
              value: isDarkTheme,
              onChanged: (value) {
                _toggleTheme();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Primary Color',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(
                height: 50,
                width: double.infinity,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                'Secondary Color',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(
                height: 50,
                width: double.infinity,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Primary Button'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Secondary Button'),
              ),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite,
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Input Field',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sample Text',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Prueba de imput',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sample Text',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Input Field',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
