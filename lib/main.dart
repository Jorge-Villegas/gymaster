import 'package:flutter/material.dart';
import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/seeders/database_seeder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseHelper.instance.database;
    DatabaseSeeder().seedGenerateDatabase();
    // EjerciciosService().eliminarEjercicoMusculo();
    // EjerciciosService().eliminarEjercicios();

    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
