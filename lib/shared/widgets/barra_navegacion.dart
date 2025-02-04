import 'package:flutter/material.dart';
import 'package:gymaster/features/record/presentation/pages/historial_ejercicios_page.dart';
import 'package:gymaster/features/routine/presentation/pages/lista_rutina_page.dart';
import 'package:gymaster/features/setting/presentation/pages/setting_page.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

void main() => runApp(const BottomNavigationBarExampleApp());

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const ListaRutinasPage(),
    const BusinessPage(),
    HistorialEjerciciosPage(),
    SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(IconsaxPlusLinear.home_1),
            label: 'Home',
            activeIcon: Icon(IconsaxPlusBold.home_1),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconsaxPlusLinear.user),
            label: 'User',
            activeIcon: Icon(IconsaxPlusBold.user),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconsaxPlusLinear.book),
            label: 'Historial',
            activeIcon: Icon(IconsaxPlusBold.book),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconsaxPlusLinear.setting_2),
            label: 'Settings',
            activeIcon: Icon(IconsaxPlusBold.setting_2),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor:
            Theme.of(context).primaryColor, // Usar el color primario del tema
        unselectedItemColor: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.color
            ?.withOpacity(0.6), // Color del texto con opacidad
        backgroundColor: Theme.of(context)
            .scaffoldBackgroundColor, // Fondo de acuerdo al tema
        selectedFontSize: 14,
        unselectedFontSize: 14,
        iconSize: 24,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(height: 1.5),
        unselectedLabelStyle: const TextStyle(height: 1.5),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text('Home Page Content'),
      ),
    );
  }
}

class BusinessPage extends StatelessWidget {
  const BusinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Page'),
      ),
      body: const Center(
        child: Text('Business Page Content'),
      ),
    );
  }
}

class SchoolPage extends StatelessWidget {
  const SchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Page'),
      ),
      body: const Center(
        child: Text('School Page Content'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: const Center(
        child: Text('Settings Page Content'),
      ),
    );
  }
}
