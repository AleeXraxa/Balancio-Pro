import 'package:balancio_pro/constants/colors.dart';
import 'package:balancio_pro/constants/fonts.dart';
import 'package:balancio_pro/controllers/auth_controller.dart';
import 'package:balancio_pro/custom%20widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EmailVerification extends StatefulWidget {
  final String email;

  const EmailVerification({
    required this.email,
    super.key,
  });

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification>
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
    _authController.emailVerificationCheck();
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
                    height: 0.2.sh,
                  ),
                  Text(
                    'Verify Your Email',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 80.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 0.02.sh),
                  Text(
                    textAlign: TextAlign.center,
                    'We have sent verification link to: \n${widget.email}',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 0.02.sh),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [],
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
                            ? _authController.resendEmail()
                            : null;
                      },
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
}
