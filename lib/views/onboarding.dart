import 'package:balancio_pro/constants/colors.dart';
import 'package:balancio_pro/services/onboarding.dart';
import 'package:balancio_pro/views/login.dart';
import 'package:balancio_pro/views/onboarding_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  bool lastpage = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1).animate(
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
        decoration: BoxDecoration(gradient: gradient),
        height: 1.sh,
        width: 1.sw,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Positioned(
                top: 100.h,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _controller.jumpToPage(2);
                        },
                        icon: Icon(Icons.close),
                        color: Colors.white,
                      ),
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: WormEffect(
                          dotWidth: 0.1.sw,
                          dotHeight: 5,
                          activeDotColor: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    lastpage = (index == 2);
                  });
                },
                children: [
                  OnboardingScreens(
                    illustration: 'assets/images/Onboarding_1.png',
                    title: 'Welcome to Balancio Pro',
                    subtext:
                        'Track your expenses, manage budgets, and take control of your finances effortlessly.',
                  ),
                  OnboardingScreens(
                    illustration: 'assets/images/Onboarding_2.png',
                    title: 'Smart Expense Tracking',
                    subtext:
                        'Easily categorize and track your spending with a single tap.',
                  ),
                  OnboardingScreens(
                    illustration: 'assets/images/Onboarding_3.png',
                    title: 'Start Managing Your Finances',
                    subtext:
                        'Set your goals, track expenses, and achieve financial stability with Balancio Pro.',
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 100.h,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: accentColor,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      elevation: 5,
                    ),
                    onPressed: () async {
                      if (lastpage) {
                        Get.offAll(Login(),
                            duration: Duration(milliseconds: 800),
                            transition: Transition.leftToRight);
                        await OnboardingCheck.isCompleted();
                      } else {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInCirc);
                      }
                    },
                    child: Text(
                      lastpage ? 'Get Started' : 'Next',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 60.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
