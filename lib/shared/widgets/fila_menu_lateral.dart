import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gymaster/shared/models/elemento_menu_modelo.dart';

class FilaMenuLateral extends StatelessWidget {
  const FilaMenuLateral({
    super.key,
    required this.elementoMenu,
    this.menuSeleccionado = "",
    this.alPresionarMenu,
  });

  final ElementoMenuModelo elementoMenu;
  final String menuSeleccionado;
  final VoidCallback? alPresionarMenu;

  @override
  Widget build(BuildContext context) {
    final estaSeleccionado = menuSeleccionado == elementoMenu.titulo;

    return Stack(
      children: [
        // Fondo animado cuando el elemento está seleccionado
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: estaSeleccionado ? 288 - 16 : 0,
          height: 56,
          curve: const Cubic(0.2, 0.8, 0.2, 1),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // Botón del elemento del menú - estilo flutter-samples
        CupertinoButton(
          padding: const EdgeInsets.all(12),
          pressedOpacity: 1,
          onPressed: () {
            print('FilaMenuLateral: Tap detectado para ${elementoMenu.titulo}');
            alPresionarMenu?.call();
          },
          child: Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: Opacity(
                  opacity: 0.6,
                  child: Icon(
                    elementoMenu.icono,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                elementoMenu.titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
