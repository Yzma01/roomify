// lib/services/auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:roomify/components/hooks/UserProvider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

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

  Future<User?> registerUser({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await authResult.user?.reload();
      final user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email.trim(),
          'name': fullName.trim(),
          'phone': phone.trim(),
          'role': role.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'uid': user.uid,
        });

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

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      if (_auth.currentUser != null) {
        throw Exception('No se pudó cerrar sesión');
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

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
