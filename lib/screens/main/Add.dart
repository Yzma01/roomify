import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AddScreen());
}

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add')
            ],
          ),
        ),
      ),
    );
  }
}