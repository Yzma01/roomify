import 'package:flutter/material.dart';

void main() {
  runApp(const FooterBar());
}

class FooterBar extends StatelessWidget {
  const FooterBar({Key? key}) : super(key: key);

Widget _iconWidget(){
  return Expanded(child: 
  IconButton(onPressed: (){}, icon: Icon(Icons.home)));
}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            children: [
              _iconWidget(),
              _iconWidget(),
              _iconWidget(),
              _iconWidget(),
            ],
        ),
      ),
    );
  }
}