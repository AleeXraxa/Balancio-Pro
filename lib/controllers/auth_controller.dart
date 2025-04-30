import 'dart:async';

import 'package:balancio_pro/custom%20widgets/snackbar.dart';
import 'package:balancio_pro/model/usermodel.dart';
import 'package:balancio_pro/views/auth/email_verification.dart';
import 'package:balancio_pro/views/auth/login.dart';
import 'package:balancio_pro/views/auth/profile_setup.dart';
import 'package:balancio_pro/views/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPassController.clear();
  }

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
        passwordController.clear();
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
        confirmPassController.clear();
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
      clearControllers();
      if (!userCredential.user!.emailVerified) {
        userCredential.user!.sendEmailVerification();
        Get.offAll(
            EmailVerification(
              email: userCredential.user!.email!,
            ),
            duration: Duration(milliseconds: 800),
            transition: Transition.leftToRight);
      } else {
        Get.offAll(Login(),
            duration: Duration(milliseconds: 800),
            transition: Transition.leftToRight);
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Custombar.showBar(
          'Login failed',
          'Login canceled',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );
        clearControllers();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credentials);

      bool isCompleted = await checkProfileCompleted();

      if (isCompleted) {
        Custombar.showBar(
          'Login Successfully',
          'Welcome Dear ${userCredential.user?.displayName ?? 'User'}',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );
        Get.offAll(Dashboard(),
            duration: Duration(milliseconds: 800),
            transition: Transition.leftToRight);
      } else {
        Get.offAll(ProfileSetup(),
            duration: Duration(milliseconds: 800),
            transition: Transition.leftToRight);
        Custombar.showBar(
          'Complete Profile',
          'Please complete your profile first',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );
        clearControllers();
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    } catch (e) {
      Custombar.showBar(
        'Login failed',
        'Something went wrong during Google Sign-In',
        [Colors.purple, Colors.blueAccent],
        Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser() async {
    try {
      final email = emailController.text.trim();
      final pass = passwordController.text.trim();

      if (email.isEmpty && pass.isEmpty) {
        Custombar.showBar(
          'Login Failed',
          'Please fill all the fields',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );
        return;
      }
      if (email.isEmpty) {
        Custombar.showBar(
          'Login Failed',
          'Please enter your email',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );
        return;
      }
      if (pass.isEmpty) {
        Custombar.showBar(
          'Login Failed',
          'Please enter your password',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );
        return;
      }
      isLoading.value = true;
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        userCredential.user!.sendEmailVerification();
        Get.offAll(
            EmailVerification(
              email: userCredential.user!.email!,
            ),
            duration: Duration(milliseconds: 800),
            transition: Transition.leftToRight);
      } else {
        bool isCompleted = await checkProfileCompleted();

        if (isCompleted) {
          Custombar.showBar(
            'Login Successfully',
            'Welcome Dear ${userCredential.user?.displayName ?? 'User'}',
            [Colors.purple, Colors.blueAccent],
            Colors.white,
          );
          Get.offAll(Dashboard(),
              duration: Duration(milliseconds: 800),
              transition: Transition.leftToRight);
        } else {
          Get.offAll(ProfileSetup(),
              duration: Duration(milliseconds: 800),
              transition: Transition.leftToRight);
          Custombar.showBar(
            'Complete Profile',
            'Please complete your profile first',
            [Colors.purple, Colors.blueAccent],
            Colors.white,
          );
        }
      }
      clearControllers();
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    } catch (e) {
      Custombar.showBar(
        'Login Failed',
        'Please try again later.',
        [Colors.purple, Colors.blueAccent],
        Colors.white,
      );
      emailController.clear();
      passwordController.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void emailVerificationCheck() async {
    var user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      Custombar.showBar(
        'Email Verified',
        'Email successfully verified. now you can login',
        [Colors.blueAccent, Colors.purpleAccent],
        Colors.white,
      );
      Get.offAll(Login(),
          duration: Duration(milliseconds: 800),
          transition: Transition.leftToRight);
    } else {
      await Future.delayed(Duration(seconds: 3));
      await _auth.currentUser?.reload();
      var currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.emailVerified) {
        Get.offAll(Login(),
            duration: Duration(milliseconds: 800),
            transition: Transition.leftToRight);
        Custombar.showBar(
          'Email Verified',
          'Email successfully verified. now you can login',
          [Colors.blueAccent, Colors.purpleAccent],
          Colors.white,
        );
      } else {
        emailVerificationCheck();
      }
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

  void resendEmail() async {
    try {
      var user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        startResendCoolDown();
        Custombar.showBar(
          'Email Sent',
          'Please check your email & verify your account',
          [Colors.red, Colors.deepOrange],
          Colors.white,
        );
      } else if (user == null) {
        Custombar.showBar(
          'Login First',
          'No user is currently logged in.',
          [Colors.red, Colors.deepOrange],
          Colors.white,
        );
      } else {
        Custombar.showBar(
          'Already Verified',
          'Your email is already verified. Please login.',
          [Colors.red, Colors.deepOrange],
          Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    } catch (e) {
      Custombar.showBar(
        'Failed',
        'Something went wrong. Please try again later',
        [Colors.red, Colors.deepOrange],
        Colors.white,
      );
    }
  }

  Future<void> passReset(String userEmail) async {
    try {
      isLoading.value = true;

      if (userEmail.isEmpty) {
        Custombar.showBar(
          'Reset Failed',
          'Please enter your email',
          [Colors.purple, Colors.blueAccent],
          Colors.white,
        );

        return;
      }
      await _auth.sendPasswordResetEmail(email: userEmail);
      Custombar.showBar(
        'Success',
        'Password reset email sent. Check your inbox.',
        [Colors.purple, Colors.blueAccent],
        Colors.white,
      );
      startResendCoolDown();
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    } catch (e) {
      Custombar.showBar(
        'Failed',
        'Something went wrong. Please try again later',
        [Colors.red, Colors.deepOrange],
        Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  RxInt resendCoolDown = 0.obs;

  void startResendCoolDown() {
    resendCoolDown.value = 30;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendCoolDown.value == 0) {
        timer.cancel();
      } else {
        resendCoolDown.value--;
      }
    });
  }

  Future<void> saveUserData({
    required String uid,
    required String fname,
    required String lname,
    required String gender,
    required bool isCompleted,
  }) async {
    Usermodel user = Usermodel(
      uid: uid,
      fname: fname,
      lname: lname,
      gender: gender,
      isCompleted: isCompleted,
    );
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(user.toMap());
    } catch (e) {
      Custombar.showBar(
        'Failed',
        'Something went wrong. Please try again later',
        [Colors.red, Colors.deepOrange],
        Colors.white,
      );
    }
  }

  Future<bool> checkProfileCompleted() async {
    var user = _auth.currentUser;

    if (user != null) {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        var data = userData.data();
        return data?['isCompleted'] ?? false;
      }
    }
    return false;
  }

  final fname = ''.obs;
  final lname = ''.obs;
  final gender = ''.obs;

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      Custombar.showBar(
        'Failed',
        'Something went wrong. Please try again later',
        [Colors.red, Colors.deepOrange],
        Colors.white,
      );
      return null;
    }
  }

  void loadData() async {
    if (_auth.currentUser == null) return;
    String uid = _auth.currentUser!.uid;
    Map<String, dynamic>? userData = await getUserData(uid);
    if (userData != null) {
      fname.value = userData['fname'];
      lname.value = userData['lname'];
      gender.value = userData['gender'];
    }
  }

  void checkLoginStatus() {
    User? user = _auth.currentUser;
    if (user != null) {
      Get.offAll(Dashboard(),
          duration: Duration(milliseconds: 800),
          transition: Transition.leftToRight);
    } else {
      Get.offAll(Login(),
          duration: Duration(milliseconds: 800),
          transition: Transition.leftToRight);
    }
  }

  Future<void> logoutUser() async {
    try {
      isLoading.value = true;

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Also sign out from Google if signed in
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      Custombar.showBar(
        'Logout Successful',
        'You have been logged out.',
        [Colors.purple, Colors.blueAccent],
        Colors.white,
      );

      // Redirect to login screen
      Get.offAll(Login(),
          duration: Duration(milliseconds: 800),
          transition: Transition.leftToRight);
    } catch (e) {
      Custombar.showBar(
        'Logout Failed',
        'Something went wrong while logging out.',
        [Colors.red, Colors.deepOrange],
        Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
  }
}
