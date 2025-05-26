import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:roomify/screens/login/Login.dart';
import 'package:roomify/screens/login/ForgotPassword.dart';
import 'package:roomify/screens/login/SignUp.dart';
import 'package:provider/provider.dart';
import 'package:roomify/components/hooks/UserProvider.dart';
import 'package:roomify/screens/main/Property.dart';
import 'package:roomify/screens/profile/EditProfile.dart';
import 'package:roomify/services/main_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const bg = Color.fromARGB(255, 246, 246, 246);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roomify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        appBarTheme: AppBarTheme(
          backgroundColor: bg,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/main': (context) => MainContainer(),
        '/edit-profile':(context)=>EditProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/property/') ?? false) {
          final String propertyId = settings.name!.split('/')[2];
          return MaterialPageRoute(
            builder: (context) => PropertyScreen(id: propertyId),
          );
        }
      },
    );
  }
}