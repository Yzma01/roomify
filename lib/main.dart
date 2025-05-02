import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:roomify/home/Home.dart';
import 'package:roomify/login/Login.dart';
import 'package:roomify/password/ForgotPassword.dart';
import 'package:roomify/register/SignUp.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' Roomify ',
      initialRoute: '/ ',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context)=> SignUpScreen(),
        '/home ': (context) => HomeScreen(),
        '/forgot-password': (context)=>ForgotPasswordScreen(),
      },
    );
  }
}
