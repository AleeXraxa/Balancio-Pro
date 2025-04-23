import 'package:balancio_pro/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomField extends StatefulWidget {
  final String labelText;
  final IconData? prefix;
  final IconData? suffix;
  final bool isPass;
  final TextEditingController controller;
  final VoidCallback? onTapSuffix;

  const CustomField({
    required this.labelText,
    this.prefix,
    this.suffix,
    this.isPass = false,
    required this.controller,
    this.onTapSuffix,
    super.key,
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.isPass,
      controller: widget.controller,
      style: TextStyle(
        color: accentColor,
      ),
      decoration: InputDecoration(
        fillColor: primaryColor,
        filled: true,
        prefixIcon: widget.prefix != null
            ? Padding(
                padding: EdgeInsets.only(left: 24, right: 8),
                child: Icon(widget.prefix),
              )
            : null,
        suffixIcon: widget.suffix != null
            ? Padding(
                padding: EdgeInsets.only(left: 8, right: 14),
                child: IconButton(
                  onPressed: widget.onTapSuffix,
                  icon: Icon(widget.suffix),
                ),
              )
            : null,
        prefixIconColor: accentColor,
        suffixIconColor: accentColor,
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: const Color.fromARGB(199, 234, 234, 234),
          fontSize: 45.sp,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
