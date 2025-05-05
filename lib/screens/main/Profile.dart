import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomify/components/hooks/UserProvider.dart';
import 'package:roomify/screens/login/Login.dart';
import 'package:roomify/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  ProfileScreen({Key? key}) : super(key: key);
  Future<void> logOut(BuildContext context) async {
    final scaffold = ScaffoldMessenger.of(context);
    final authService = AuthService();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Mostrar loading
      scaffold.showSnackBar(SnackBar(content: Text('Cerrando sesión...')));

      // 1. Cerrar sesión en Firebase
      await authService.signOut();

      // 2. Limpiar el estado local
      userProvider.clearUser();

      // 3. Navegar a Login y limpiar stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );

      // 4. Mostrar confirmación
      scaffold.showSnackBar(
        SnackBar(content: Text('Sesión cerrada exitosamente')),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Profile'),
              IconButton(
                onPressed: () => logOut(context),
                icon: Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
