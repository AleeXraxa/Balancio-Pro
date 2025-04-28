import 'package:balancio_pro/constants/colors.dart';
import 'package:balancio_pro/constants/fonts.dart';
import 'package:balancio_pro/controllers/auth_controller.dart';
import 'package:balancio_pro/services/onboarding.dart';
import 'package:balancio_pro/views/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;

  late AnimationController _textController;
  late Animation<Offset> _textAnimation;

  final _authController = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    _logoController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoRotate = Tween<double>(begin: 5, end: 0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _textController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _textAnimation =
        Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _logoController.forward().then((_) {
      _textController.forward();
    });
    navigate();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void navigate() async {
    await Future.delayed(_logoController.duration! +
        _textController.duration! +
        Duration(seconds: 2));
    final isFirst = await OnboardingCheck.isFirstTime();
    if (isFirst) {
      Get.offAll(Onboarding(),
          duration: Duration(milliseconds: 800),
          transition: Transition.leftToRight);
    } else {
      _authController.checkLoginStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..scale(_logoScale.value)
                    ..rotateZ(_logoRotate.value),
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: SizedBox(
                width: 0.8.sw,
                height: 0.2.sh,
                child: Image.asset('assets/images/splash.png'),
              ),
            ),
            SlideTransition(
              position: _textAnimation,
              child: Row(
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
            )
          ],
        ),
      ),
    );
  }
}
