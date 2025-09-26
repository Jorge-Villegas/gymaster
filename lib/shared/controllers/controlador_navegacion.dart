import 'package:flutter/material.dart';

class ControladorNavegacion extends ChangeNotifier {
  int _indiceSeleccionado = 0;
  String _menuLateralSeleccionado = 'Mis Rutinas';

  int get indiceSeleccionado => _indiceSeleccionado;
  String get menuLateralSeleccionado => _menuLateralSeleccionado;

  void cambiarIndice(int nuevoIndice) {
    _indiceSeleccionado = nuevoIndice;

    // Sincronizar con el menú lateral
    switch (nuevoIndice) {
      case 0:
        _menuLateralSeleccionado = 'Mis Rutinas';
        break;
      case 1:
        _menuLateralSeleccionado = 'Favoritos';
        break;
      case 2:
        _menuLateralSeleccionado = 'Catálogo de Ejercicios';
        break;
      case 3:
        _menuLateralSeleccionado = 'Historial de Entrenamientos';
        break;
      case 4:
        _menuLateralSeleccionado = 'Configuración';
        break;
    }

    notifyListeners();
  }

  void cambiarMenuLateral(String nuevoMenu) {
    _menuLateralSeleccionado = nuevoMenu;

    // Sincronizar con la barra de navegación inferior
    switch (nuevoMenu) {
      case 'Mis Rutinas':
        _indiceSeleccionado = 0;
        break;
      case 'Catálogo de Ejercicios':
        _indiceSeleccionado = 2;
        break;
      case 'Historial de Entrenamientos':
        _indiceSeleccionado = 3;
        break;
      case 'Configuración':
        _indiceSeleccionado = 4;
        break;
      case 'Mi Progreso':
        // Para progreso mantenemos el historial
        _indiceSeleccionado = 3;
        break;
      default:
        _indiceSeleccionado = 0;
        break;
    }

    notifyListeners();
  }
}
