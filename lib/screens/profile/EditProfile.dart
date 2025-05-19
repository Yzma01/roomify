import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roomify/components/actions/Button.dart';
import 'package:roomify/components/hooks/UserProvider.dart';
import 'package:roomify/components/inputs/ComboBox.dart';
import 'package:roomify/components/inputs/Input.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userFullNameController = TextEditingController();
  final _userPhoneController = TextEditingController();

  String? _role;
  bool _isLoading = false;

  String? validateEmail(String? value) {
    if (value!.isEmpty) return 'Ingrese su email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email no válido';
    }
    return null;
  }

  Future<void> updateUser({
    required String fullname,
    required String email,
    required String phone,
    required String role,
    required BuildContext context,
  }) async {
    setState(() {
      _isLoading = true;
    });
    final user = Provider.of<UserProvider>(context, listen: false).user;

    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Usuario no autenticado');
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'name': fullname, 'email': email, 'phone': phone, 'role': role},
      );
      await Provider.of<UserProvider>(context, listen: false).loadUser();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil actualizado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).userData;
    _userFullNameController.text = user?['name'] ?? '';
    _userEmailController.text = user?['email'] ?? '';
    _userPhoneController.text = user?['phone'] ?? '';
    _role = user?['role'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Perfil')),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: Column(
              children: [
                //Name
                Input(
                  controller: _userFullNameController,
                  prefixIcon: Icon(Icons.person),
                  label: 'Nombre Completo',
                  validator:
                      (value) => value!.isEmpty ? 'Ingrese su nombre' : null,
                ),
                //Email
                Input(
                  controller: _userEmailController,
                  prefixIcon: Icon(Icons.email),
                  label: 'Correo Electrónico',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    return validateEmail(value);
                  },
                ),
                //Phone
                Input(
                  controller: _userPhoneController,
                  prefixIcon: Icon(Icons.phone),
                  label: 'Teléfono',
                  keyboardType: TextInputType.phone,
                  validator:
                      (value) => value!.isEmpty ? 'Ingrese su teléfono' : null,
                ),

                //Password
                ComboBox(
                  items: ['Estudiante', 'Arrendatario'],
                  icon: Icons.list,
                  label: 'Role',
                  initialValue: _role,
                  onChanged: (value) {
                    _role = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione un role';
                    }
                  },
                ),
                const SizedBox(height: 40),
                Button(
                  isLoading: _isLoading,
                  onPressed: () async {
                    await updateUser(
                      fullname: _userFullNameController.text,
                      context: context,
                      email: _userEmailController.text,
                      phone: _userPhoneController.text,
                      role: _role!,
                    );
                  },
                  label: 'Guardar',
                  fontSize: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
