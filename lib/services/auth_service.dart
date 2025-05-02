// lib/services/auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método mejorado para iniciar sesión
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Usamos una variable temporal para evitar problemas de casteo
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      // Forzamos un reload para asegurar los datos del usuario
      await authResult.user?.reload();
      final user = _auth.currentUser;
      
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        throw Exception('Por favor verifica tu email antes de iniciar sesión');
      }
      
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('Error en el proceso de login: $e');
    }
  }

  // Método mejorado para registrar usuario
  Future<User?> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    try {
      // 1. Crear usuario en Firebase Auth
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // 2. Esperar a que el usuario esté completamente inicializado
      await authResult.user?.reload();
      final user = _auth.currentUser;

      if (user != null) {
        // 3. Guardar información adicional en Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email.trim(),
          'name': fullName.trim(),
          'phone': phone.trim(),
          'createdAt': FieldValue.serverTimestamp(), // Mejor usar serverTimestamp
          'role': 'user',
          'uid': user.uid, // Añadir UID explícitamente
        });

        // 4. Enviar email de verificación (sin esperar)
        user.sendEmailVerification();
        
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('Error en el registro: $e');
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Método para recuperación de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Manejo mejorado de errores
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'invalid-email':
        return 'Correo electrónico no válido.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'user-not-found':
        return 'Usuario no encontrado.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'operation-not-allowed':
        return 'Operación no permitida.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intente más tarde.';
      default:
        return 'Error de autenticación: ${e.message ?? e.code}';
    }
  }
}