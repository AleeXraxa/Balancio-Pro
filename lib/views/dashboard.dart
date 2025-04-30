import 'dart:ui';

import 'package:balancio_pro/constants/colors.dart';
import 'package:balancio_pro/controllers/auth_controller.dart';
import 'package:balancio_pro/custom%20widgets/chart.dart';
import 'package:balancio_pro/custom%20widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
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
    _authController.loadData();
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
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                children: [
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 20),
                      child: Container(
                        height: 0.08.sh,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => Text(
                                  'Welcome, ${_authController.fname.value}',
                                  style: TextStyle(
                                    fontSize: 60.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _authController.logoutUser();
                                },
                                icon: Icon(Icons.logout_rounded),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.01.sh),
                  Text(
                    'Manage your daily expenses easily',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.sp,
                    ),
                  ),
                  SizedBox(height: 0.05.sh),
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 20),
                      child: Container(
                        height: 0.32.sh,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Balance',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.70),
                                  fontSize: 50.sp,
                                ),
                              ),
                              Text(
                                'Rs. 24000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 120.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.01.sh),
                              ContainerCard(
                                width: double.infinity,
                                height: 0.07.sh,
                                bgColor: Color(0xff155E4B),
                                leftText: 'Total Income',
                                rightText: 'Rs. 28000',
                              ),
                              SizedBox(height: 0.01.sh),
                              ContainerCard(
                                width: double.infinity,
                                height: 0.07.sh,
                                bgColor: Color(0xff8A1515),
                                leftText: 'Total Expenses',
                                rightText: 'Rs. 4000',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.02.sh),
                  Text(
                    'Income vs Expense',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 0.04.sh),
                  CustomChart(income: 28000, expense: 12000),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
