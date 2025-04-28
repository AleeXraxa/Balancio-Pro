import 'package:balancio_pro/constants/colors.dart';
import 'package:balancio_pro/constants/fonts.dart';
import 'package:balancio_pro/controllers/auth_controller.dart';
import 'package:balancio_pro/custom%20widgets/button.dart';
import 'package:balancio_pro/custom%20widgets/snackbar.dart';
import 'package:balancio_pro/custom%20widgets/textfield.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup>
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
  }

  final _authController = Get.put(AuthController());
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  RxString selectedGender = 'Male'.obs;

  void sendData() {
    var firstName = _fname.text.trim();
    var lastName = _lname.text.trim();
    if (firstName.isEmpty && lastName.isEmpty) {
      Custombar.showBar(
        'Failed',
        'Please enter all fields ',
        [Colors.red, Colors.deepOrange],
        Colors.white,
      );
    }
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _authController.saveUserData(
        uid: user.uid,
        fname: firstName,
        lname: lastName,
        gender: selectedGender.value,
        isCompleted: true,
      );
    }
    Custombar.showBar(
      'Profile Completed',
      'Your data has been saved successfully.',
      [Colors.red, Colors.deepOrange],
      Colors.white,
    );
    _fname.clear();
    _lname.clear();
    selectedGender.value = 'Male';
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
                    height: 0.05.sh,
                  ),
                  Text(
                    'Profile Setup',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 80.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Let's get to know you better!",
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 0.05.sh),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomField(
                        controller: _fname,
                        labelText: 'First Name',
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      CustomField(
                        controller: _lname,
                        labelText: 'Last Name',
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                    ],
                  ),
                  DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                      fillColor: primaryColor,
                      filled: true,
                      labelText: 'Select Gender',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(199, 234, 234, 234),
                        fontSize: 45.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white, // Selected value ka text color
                      fontSize: 45.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    value: selectedGender.value,
                    items: ['Male', 'Female'].map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(
                          gender,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        selectedGender.value = value;
                      }
                    },
                  ),
                  SizedBox(height: 40.h),
                  CustomButton(
                    buttonText: 'Complete',
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    bgColor: primaryColor,
                    borderRadius: 12,
                    onPressed: () {
                      sendData();
                    },
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
