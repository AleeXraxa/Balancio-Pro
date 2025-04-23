import 'package:balancio_pro/custom%20widgets/snackbar.dart';
import 'package:balancio_pro/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  RxBool isPass = true.obs;
  RxBool isConfirmPass = true.obs;

  void showPass() {
    isPass.value = !isPass.value;
  }

  void showConfirmPass() {
    isConfirmPass.value = !isConfirmPass.value;
  }

  Future<void> registerUser() async {
    try {
      final email = emailController.text.trim();
      final pass = passwordController.text.trim();
      final cPass = confirmPassController.text.trim();

      if (email.isEmpty && pass.isEmpty && cPass.isEmpty) {
        Custombar.showBar(
          'Registration Failed',
          'Please fill all the fields',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );
        return;
      }
      if (email.isEmpty) {
        Custombar.showBar(
          'Registration Failed',
          'Please enter your email',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );
        return;
      }
      if (pass.isEmpty ||
          pass.length < 6 ||
          !pass.contains(RegExp(r'[A-Z]')) ||
          !pass.contains(RegExp(r'[a-z]')) ||
          !pass.contains(RegExp(r'[0-9]'))) {
        Custombar.showBar(
          'Registration Failed',
          'Password must be at least 6 characters and include uppercase, lowercase, and a number.',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );
        return;
      }

      if (cPass.isEmpty) {
        Custombar.showBar(
          'Registration Failed',
          'Please enter confirm password',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );
        return;
      }
      if (cPass != pass) {
        Custombar.showBar(
          'Registration Failed',
          'Password does not match',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );
        return;
      }

      isLoading.value = true;
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      Custombar.showBar(
        'Registration Success',
        'Your account has been created successfully',
        [Colors.purple, Colors.blueAccent],
        Colors.white,
      );
      Get.offAll(Login(),
          duration: Duration(milliseconds: 800),
          transition: Transition.leftToRight);
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        Custombar.showBar(
          'Registration Failed',
          'This email is already in use.',
          [Colors.red, Colors.deepOrange],
          Colors.white,
        );
        break;

      case 'invalid-email':
        Custombar.showBar(
          'Registration Failed',
          'Invalid email format.',
          [Colors.red, Colors.deepOrange],
          Colors.white,
        );
        break;

      case 'weak-password':
        Custombar.showBar(
          'Registration Failed',
          'Password is too weak.',
          [Colors.red, Colors.deepOrange],
          Colors.white,
        );
        break;

      case 'user-not-found':
        Custombar.showBar(
          'Login Failed',
          'No user found with this email.',
          [Colors.red, Colors.deepOrange],
          Colors.white,
        );
        break;

      case 'wrong-password':
        Custombar.showBar(
          'Login Failed',
          'Incorrect password.',
          [Colors.red, Colors.deepOrange],
          Colors.white,
        );
        break;

      case 'too-many-requests':
        Custombar.showBar(
          'Request Blocked',
          'Too many attempts. Try again later.',
          [Colors.red, Colors.deepOrange],
          Colors.white,
        );
        break;

      default:
        Custombar.showBar(
          'Error',
          'Something went wrong. Please try again.',
          [Colors.red, Colors.deepOrange],
          Colors.white,
        );
    }
  }
}
