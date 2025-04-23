import 'package:balancio_pro/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final EdgeInsetsGeometry padding;
  final Color bgColor;
  final double borderRadius;
  final VoidCallback? onPressed;

  const CustomButton({
    this.onPressed,
    required this.buttonText,
    required this.padding,
    required this.bgColor,
    required this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: padding,
            backgroundColor: bgColor,
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 60.sp,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
      ),
    );
  }
}
