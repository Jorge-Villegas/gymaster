import 'package:flutter/material.dart';

class ItemsPesosWidget extends StatefulWidget {
  final int items;
  const ItemsPesosWidget({
    super.key,
    required this.items,
  });

  @override
  State<ItemsPesosWidget> createState() => _ItemsPesosWidgetState();
}

class _ItemsPesosWidgetState extends State<ItemsPesosWidget> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  double peso1 = 0;
  double peso2 = 0;
  double peso3 = 0;
  double peso4 = 0;
  double peso5 = 0;
  double peso6 = 0;
  double peso7 = 0;
  double peso8 = 0;
  double peso9 = 0;
  double peso10 = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('1  :    ', style: TextStyle(fontSize: 15)),
            SizedBox(
              width: 60,
              child: TextField(
                controller: _controller1,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 20),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
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
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('2  :    ', style: TextStyle(fontSize: 15)),
            SizedBox(
              width: 60,
              child: TextField(
                controller: _controller2,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 20),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
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
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('3  :    ', style: TextStyle(fontSize: 15)),
            SizedBox(
              width: 60,
              child: TextField(
                controller: _controller1,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 20),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
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
        ),
      ],
    );
  }
}
