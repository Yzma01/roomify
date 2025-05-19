import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  bool pets = false;
  String amount = '0';

  Widget _topBar(context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.33),
        Text("Filtros"),
      ],
    );
  }

  Widget _title(title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: TextStyle(fontSize: 18)),
    );
  }

  void setAmount(value) {
    setState(() {
      amount = value;
    });
  }

  Widget _roomText(text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: amount == text ? const Color.fromARGB(172, 102, 182, 248) : Colors.transparent,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: amount == text ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _amountOfRooms(context) {
    return Column(
      children: [
        _title('Cantidad de habitaciones: ${amount}'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => setAmount('1'),
              child: _roomText('1'),
            ),
            ElevatedButton(
              onPressed: () => setAmount('2'),
              child: _roomText('2'),
            ),
            ElevatedButton(
              onPressed: () => setAmount('3'),
              child: _roomText('3'),
            ),
            ElevatedButton(
              onPressed: () => setAmount('4'),
              child: _roomText('4'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _allowPets(context) {
    return Row(
      children: [
        _title('Se permiten mascotas'),
        Checkbox(
          value: pets,
          onChanged: (value) {
            setState(() {
              pets = value!;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [_amountOfRooms(context), _allowPets(context)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
