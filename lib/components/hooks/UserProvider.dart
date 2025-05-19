import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  Map<String, dynamic>? _userData;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;

  Future<void> loadUser() async {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .get();

      _userData = doc.data();
    }

    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
