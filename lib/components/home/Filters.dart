import 'package:flutter/material.dart';

void main() {
  runApp(const Filter());
}

class Filter extends StatelessWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.33,
                  ),
                  Text( "Filtros"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
