import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:roomify/screens/main/Add.dart';
import 'package:roomify/screens/main/Home.dart';
import 'package:roomify/screens/login/Login.dart';
import 'package:roomify/screens/main/Map.dart';
import 'package:roomify/screens/login/ForgotPassword.dart';
import 'package:roomify/screens/main/Profile.dart';
import 'package:roomify/screens/login/SignUp.dart';
import 'package:provider/provider.dart';
import 'package:roomify/components/hooks/UserProvider.dart';
import 'package:roomify/screens/main/Property.dart';
import 'package:roomify/screens/profile/EditProfile.dart';

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

class MainContainer extends StatefulWidget {
  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;
  User? _user;
  String? _role;

  final List<Widget> _screens = [
    HomeScreen(),
    MapScreen(),
    AddScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .get();
      if (doc.exists) {
        setState(() {
          _role = doc['role'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildFooter(),
    );
  }

  Widget _buildFooter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            _buildNavIcon(Icons.home, 0),
            _buildNavIcon(Icons.map, 1),
            if (_role == 'Estudiante') _buildNavIcon(Icons.add, 2),
            _buildNavIcon(Icons.person, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return Expanded(
      child: IconButton(
        icon: Icon(
          icon,
          color: _currentIndex == index ? Colors.blue : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
