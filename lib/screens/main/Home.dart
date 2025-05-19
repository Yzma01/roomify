import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomify/components/home/Filters.dart';
import 'package:roomify/components/home/Places.dart';
import 'package:roomify/components/inputs/Search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchValue = TextEditingController();

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
            child: Container(height: 500, child: const Filter()),
          ),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
    );
  }

  void _shearch() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Search(
                controller: _searchValue,
                label: 'Lugar',
                prefixIcon: IconButton(
                  onPressed: () => _shearch,
                  icon: Icon(Icons.search),
                ),
                suffixIcon: IconButton(
                  onPressed: () => _showFilters(),
                  icon: Icon(Icons.tune),
                ),
                padding: EdgeInsets.all(20),
              ),
              Places(),
            ],
          ),
        ),
      ),
    );
  }
}
