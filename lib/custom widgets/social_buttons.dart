import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButtons extends StatefulWidget {
  final String btnText;
  final String logo;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onPressed;

  const SocialButtons({
    required this.btnText,
    required this.logo,
    required this.bgColor,
    required this.textColor,
    required this.onPressed,
    super.key,
  });

  @override
  State<SocialButtons> createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: 170.h,
        width: .85.sw,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 70.w),
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              widget.logo,
              height: 100.h,
            ),
            Expanded(
              child: Text(
                widget.btnText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
