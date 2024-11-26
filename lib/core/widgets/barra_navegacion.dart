import 'package:flutter/material.dart';

class BarraNavegacion extends StatefulWidget {
  final Function currentIndex;

  const BarraNavegacion({
    super.key,
    required this.currentIndex,
  });

  @override
  State<BarraNavegacion> createState() => _BarraNavegacionState();
}

class _BarraNavegacionState extends State<BarraNavegacion> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).primaryColor,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      onTap: (index) {
        setState(() {
          _index = index;
          widget.currentIndex(index);
        });
      },
      currentIndex: _index,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Inicio',
          activeIcon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Rutina finalizadas',
          activeIcon: Icon(Icons.person),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Prueba',
          activeIcon: Icon(Icons.settings_outlined),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.download_outlined),
          label: 'Data',
          activeIcon: Icon(Icons.download),
        ),
      ],
    );
  }
}
