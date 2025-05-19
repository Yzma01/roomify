import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomify/components/hooks/UserProvider.dart';
import 'package:roomify/components/profile/ProfileCard.dart';
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
      scaffold.showSnackBar(SnackBar(content: Text('Cerrando sesión...')));
      await authService.signOut();
      userProvider.clearUser();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
      scaffold.showSnackBar(
        SnackBar(content: Text('Sesión cerrada exitosamente')),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: ${e.toString()}')),
      );
    }
  }

  handleProfileEdit() {}

  void optionNotAvailable({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Opción no disponible'),
          content: const Text('Esta opción no está disponible por el momento.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).userData;
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Icon(Icons.account_circle, size: 200),
              SizedBox(width: double.infinity, height: 10),
              Text(user?['name'], style: TextStyle(fontSize: 40)),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.blue[100],
                  ),
                  child: Text(user?['email'], style: TextStyle(fontSize: 15)),
                ),
              ),
              SizedBox(height: 40,),
              ProfileCard(
                text: 'Editar Perfil',
                icon: Icons.edit_outlined,
                haveArrow: true,
                onTap: () => Navigator.pushNamed(context, '/edit-profile'),
              ),
              ProfileCard(
                text: 'Editar Alquileres',
                icon: Icons.home_work_outlined,
                haveArrow: true,
                onTap: () => optionNotAvailable(context: context),
              ),
              ProfileCard(
                text: 'Configuraciones',
                icon: Icons.settings,
                haveArrow: true,
                onTap: () => optionNotAvailable(context: context),
              ),
              ProfileCard(
                text: 'Cerrar Sesión',
                icon: Icons.logout_sharp,
                onTap: () => logOut(context),
                haveArrow: false,
                iconColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
