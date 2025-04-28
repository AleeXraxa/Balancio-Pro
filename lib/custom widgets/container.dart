import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerCard extends StatelessWidget {
  final double width;
  final double height;
  final Color bgColor;
  final String leftText;
  final String rightText;

  const ContainerCard(
      {required this.width,
      required this.height,
      required this.bgColor,
      required this.leftText,
      required this.rightText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            leftText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 50.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            rightText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 50.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
