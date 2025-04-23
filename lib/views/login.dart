import 'package:balancio_pro/constants/colors.dart';
import 'package:balancio_pro/constants/fonts.dart';
import 'package:balancio_pro/custom%20widgets/button.dart';
import 'package:balancio_pro/custom%20widgets/snackbar.dart';
import 'package:balancio_pro/custom%20widgets/social_buttons.dart';
import 'package:balancio_pro/custom%20widgets/textfield.dart';
import 'package:balancio_pro/views/forgot_pass.dart';
import 'package:balancio_pro/views/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
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
                    'Welcome Back!',
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
                        labelText: 'Enter your email',
                        prefix: Icons.email_rounded,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      CustomField(
                        labelText: 'Enter your password',
                        prefix: Icons.password_rounded,
                        suffix: Icons.visibility,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offAll(ForgotPass(),
                              duration: Duration(milliseconds: 800),
                              transition: Transition.leftToRight);
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: const Color.fromARGB(187, 234, 234, 234),
                            fontSize: 45.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    buttonText: 'Login',
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    bgColor: primaryColor,
                    borderRadius: 12,
                    onPressed: () {
                      Custombar.showBar(
                        'Working',
                        'bar is working',
                        [Colors.purple, Colors.blueAccent],
                        Colors.white,
                      );
                    },
                  ),
                  SizedBox(height: 5.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                                color:
                                    const Color.fromARGB(90, 234, 234, 234))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.w),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 45.sp,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                                color:
                                    const Color.fromARGB(90, 234, 234, 234))),
                      ],
                    ),
                  ),
                  SocialButtons(
                    btnText: 'Continue with Google',
                    logo: 'assets/images/google_logo.png',
                    bgColor: Colors.white,
                    textColor: Colors.black,
                    onPressed: () {},
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
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
                              Get.offAll(Register(),
                                  duration: Duration(milliseconds: 800),
                                  transition: Transition.leftToRight);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: Text(
                                'Sign up now',
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
