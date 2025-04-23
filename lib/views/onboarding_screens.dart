import 'package:balancio_pro/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreens extends StatefulWidget {
  final String illustration;
  final String title;
  final String subtext;

  const OnboardingScreens(
      {required this.illustration,
      required this.title,
      required this.subtext,
      super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: 1.0.sw,
        margin: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 0.8.sw,
              height: 0.5.sh,
              child: Image.asset(widget.illustration),
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 65.sp,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.subtext,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accentColor,
                fontSize: 45.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
