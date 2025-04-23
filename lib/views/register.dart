import 'package:balancio_pro/constants/colors.dart';
import 'package:balancio_pro/constants/fonts.dart';
import 'package:balancio_pro/controllers/auth_controller.dart';
import 'package:balancio_pro/custom%20widgets/button.dart';
import 'package:balancio_pro/custom%20widgets/snackbar.dart';
import 'package:balancio_pro/custom%20widgets/textfield.dart';
import 'package:balancio_pro/views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    _animation = Tween<double>(begin: 0.0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.forward();
  }

  final _authController = Get.put(AuthController());

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 1.sh,
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Balancio',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 105.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Pro',
                        style: TextStyle(
                          fontFamily: specialFont,
                          color: logo,
                          fontSize: 45.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.05.sh,
                  ),
                  Text(
                    'Create An Account!',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 80.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sign up to start managing your expenses',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 0.05.sh),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomField(
                        controller: _authController.emailController,
                        labelText: 'Enter your email',
                        prefix: Icons.email_rounded,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Obx(
                        () => CustomField(
                          isPass: _authController.isPass.value,
                          controller: _authController.passwordController,
                          labelText: 'Enter your password',
                          suffix: _authController.isPass.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onTapSuffix: () {
                            _authController.showPass();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Obx(
                        () => CustomField(
                          isPass: _authController.isConfirmPass.value,
                          controller: _authController.confirmPassController,
                          labelText: 'Confirm your password',
                          suffix: _authController.isConfirmPass.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onTapSuffix: () {
                            _authController.showConfirmPass();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                    ],
                  ),
                  Obx(
                    () => _authController.isLoading.value
                        ? SpinKitDoubleBounce(color: Colors.white, size: 50)
                        : CustomButton(
                            buttonText: 'Sign Up',
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            bgColor: primaryColor,
                            borderRadius: 12,
                            onPressed: () {
                              _authController.registerUser();
                            },
                          ),
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: accentColor,
                        ),
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                            splashColor: Colors.white24,
                            onTap: () {
                              Get.offAll(Login(),
                                  duration: Duration(milliseconds: 800),
                                  transition: Transition.leftToRight);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: Text(
                                'Login now',
                                style: TextStyle(
                                    color: accentColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
