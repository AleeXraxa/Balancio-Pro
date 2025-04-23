import 'package:balancio_pro/custom%20widgets/snackbar.dart';
import 'package:balancio_pro/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  Future<void> registerUser(String email, String pass) async {
    try {
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
      Custombar.showBar(
        'Registration Failed',
        'Some Error',
        [Colors.purple, Colors.blueAccent],
        Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
