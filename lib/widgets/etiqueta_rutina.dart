import 'package:flutter/material.dart';

class EtiquetaRutina extends StatelessWidget {
  final String text;
  final Color color;
  final int action;
  final Icon? icon;

  const EtiquetaRutina({
    super.key,
    required this.text,
    required this.color,
    required this.action,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    //Cuando se agregar la etiqueta
    if (action == 1) {
      return CircleAvatar(
        backgroundColor: color.withOpacity(0.3),
        radius: 25,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      );
    }
    //cuando solo se agregar solo el color de la etiqueta
    if (action == 2) {
      return CircleAvatar(
        backgroundColor: color.withOpacity(0.8),
        radius: 25,
      );
    }
    //Solo para mostrar
    //|una ves finalizado todo
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.80),
      radius: 25,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
