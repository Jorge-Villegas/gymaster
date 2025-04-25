import 'package:flutter/material.dart';

class SearchDelegateCustom extends SearchDelegate<String> {
  ///PARTE SUPERIOR DERECHA DEL WIDGET
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  /// PARTE SUPERIOR IZQUIERDA DEL WIDGET
  /// Por lo general va el icono de regresar
  /// Un widget para mostrar antes de la consulta actual en AppBar
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        //close(context, Navigator.of(context).pop());
      },
    );
  }

  /// Los resultados que se muestran después de que el usuario
  /// envía una búsqueda desde la página de búsqueda.
  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  /// Esto es lo que se muestra la primera ves que se entrara en la página.
  /// Sugerencias que se muestran en el cuerpo de la página de búsqueda
  /// mientras el usuario escribe una consulta en el campo de búsqueda.
  @override
  Widget buildSuggestions(BuildContext context) {
    return const ListTile(
      title: Text('Suggestions'),
    );
  }
}
