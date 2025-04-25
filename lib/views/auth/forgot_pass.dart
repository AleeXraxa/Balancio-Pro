import 'package:balancio_pro/constants/colors.dart';
import 'package:balancio_pro/constants/fonts.dart';
import 'package:balancio_pro/controllers/auth_controller.dart';
import 'package:balancio_pro/custom%20widgets/button.dart';
import 'package:balancio_pro/custom%20widgets/textfield.dart';
import 'package:balancio_pro/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass>
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
  final TextEditingController _email = TextEditingController();

  void reset() {
    _authController.passReset(_email.text.trim());
    _email.clear();
  }

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
                    'Forgot Password?',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 80.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Login to your account',
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
                        controller: _email,
                        labelText: 'Enter your email',
                        prefix: Icons.email_rounded,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                    ],
                  ),
                  Obx(
                    () => CustomButton(
                      buttonText: _authController.resendCoolDown.value == 0
                          ? 'Resend'
                          : 'Resend in ${_authController.resendCoolDown.value}',
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      bgColor: primaryColor,
                      borderRadius: 12,
                      onPressed: () {
                        _authController.resendCoolDown.value == 0
                            ? reset()
                            : null;
                      },
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                                'Back to Login',
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
