// lib/screens/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:roomify/components/actions/Button.dart';
import 'package:roomify/components/inputs/ComboBox.dart';
import 'package:roomify/components/inputs/Input.dart';
import 'package:roomify/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userFullNameController = TextEditingController();
  final _userPhoneController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _role;

  final AuthService _authService = AuthService();

  bool _passwordsMatch() {
    return _userPasswordController.text == _confirmPasswordController.text;
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_passwordsMatch()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.registerUser(
        email: _userEmailController.text,
        password: _userPasswordController.text,
        fullName: _userFullNameController.text,
        phone: _userPhoneController.text,
        role: _role!,
      );

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(60.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Registro", style: TextStyle(fontSize: 60)),
                  SizedBox(height: 60),
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
                  Input(
                    controller: _userPasswordController,
                    prefixIcon: Icon(Icons.lock),
                    label: 'Contraseña',
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value!.isEmpty) return 'Ingrese una contraseña';
                      if (value.length < 6) return 'Mínimo 6 caracteres';
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed:
                          () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  //Confirm Password
                  Input(
                    controller: _confirmPasswordController,
                    prefixIcon: Icon(Icons.lock),
                    label: 'Confirmar Contraseña',
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (!_passwordsMatch()) return 'Las contraseñas no coinciden';
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed:
                          () => setState(
                            () =>
                                _obscureConfirmPassword = !_obscureConfirmPassword,
                          ),
                    ),
                  ),
                  ComboBox(
                    items: ['Estudiante', 'Arrendatario'],
                    icon: Icons.list,
                    label: 'Role',
                    onChanged: (value){
                      _role = value;
                    },
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Seleccione un role';
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  Button(
                    isLoading: _isLoading,
                    onPressed: validateForm,
                    label: 'Crear Cuenta',
                    fontSize: 20,
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      child: IconButton(
                        onPressed:
                            () => Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (Route<dynamic> route) => false,
                            ),
                        icon: Icon(
                          Icons.arrow_back,
                          color: const Color.fromARGB(160, 0, 0, 0),
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validateForm() {
    if (_formKey.currentState!.validate()) {
      if (_role == null) {
        return;
      }
      _registerUser();
    }
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) return 'Ingrese su email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email no válido';
    }
    return null;
  }

  @override
  void dispose() {
    _userEmailController.dispose();
    _userPasswordController.dispose();
    _userFullNameController.dispose();
    _userPhoneController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
