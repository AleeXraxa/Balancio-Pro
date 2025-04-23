import 'package:balancio_pro/constants/colors.dart';
import 'package:balancio_pro/constants/fonts.dart';
import 'package:balancio_pro/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1170, 2532), minTextAdapt: true);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Balancio Pro',
      theme: ThemeData(
        primaryColor: primaryColor,
        hintColor: accentColor,
        fontFamily: primaryFont,
        useMaterial3: true,
      ),
      home: Splash(),
    );
  }
}
