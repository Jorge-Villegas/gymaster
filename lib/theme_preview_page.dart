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
    final textTheme = Theme.of(context).textTheme;
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
        body: SingleChildScrollView(
          child: Padding(
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
                ),
                const Text(
                  'Comparación de Fuentes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Flutter Default',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 8),
                          Text('Display Large',
                              style: textTheme.displayLarge
                                  ?.copyWith(fontFamily: null)),
                          Text('Display Medium',
                              style: textTheme.displayMedium
                                  ?.copyWith(fontFamily: null)),
                          Text('Display Small',
                              style: textTheme.displaySmall
                                  ?.copyWith(fontFamily: null)),
                          Text('Headline Large',
                              style: textTheme.headlineLarge
                                  ?.copyWith(fontFamily: null)),
                          Text('Body Large',
                              style: textTheme.bodyLarge
                                  ?.copyWith(fontFamily: null)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Theme',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 8),
                          Text('Display Large', style: textTheme.displayLarge),
                          Text('Display Medium',
                              style: textTheme.displayMedium),
                          Text('Display Small', style: textTheme.displaySmall),
                          Text('Headline Large',
                              style: textTheme.headlineLarge),
                          Text('Body Large', style: textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Montserrat',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 8),
                          Text('Display Large',
                              style: textTheme.displayLarge
                                  ?.copyWith(fontFamily: 'Montserrat')),
                          Text('Display Medium',
                              style: textTheme.displayMedium),
                          Text('Display Small',
                              style: textTheme.displaySmall
                                  ?.copyWith(fontFamily: 'Montserrat')),
                          Text('Headline Large',
                              style: textTheme.headlineLarge
                                  ?.copyWith(fontFamily: 'Montserrat')),
                          Text('Body Large',
                              style: textTheme.bodyLarge
                                  ?.copyWith(fontFamily: 'Montserrat')),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Prueba de Fuente',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'System', // Fuente del sistema
                  ),
                ),
                const Text(
                  'Prueba de Fuente',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Verificación explícita de la fuente
                Text(
                  'Fuente actual: ${Theme.of(context).textTheme.bodyLarge?.fontFamily ?? "No definida"}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
