// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/core/theme/espaciado.dart';

// ignore: must_be_immutable
class ItemPesoWidget extends StatefulWidget {
  int items;
  ItemPesoWidget({
    super.key,
    required this.items,
  });

  @override
  State<ItemPesoWidget> createState() => _ItemPesoWidgetState();
}

class _ItemPesoWidgetState extends State<ItemPesoWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${widget.items.toString()}  : ',
          style: TipografiaGyMaster.textoPrincipal,
        ),
        SizedBox(
          width: 60,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            style: TipografiaGyMaster.contadorPesoTiempo,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: Espaciado.rellenoXs,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black45,
              backgroundColor: Colors.grey[200],
            ),
            onPressed: () {
              setState(() {});
            },
            child: const Icon(Icons.add),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.5),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black45,
              backgroundColor: Colors.grey[200],
            ),
            child: const Icon(Icons.remove),
            onPressed: () {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
