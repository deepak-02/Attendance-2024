import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home/dashboard.dart';
import '../screens/login/login_page.dart';

class AnimatedProgressBar extends StatefulWidget {
  const AnimatedProgressBar({super.key});

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  dynamic email;
  @override
  void initState() {
    super.initState();
    getData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Add a listener to rebuild the widget when the animation updates
    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.offAll(
            email == null || email == "" ? const LoginPage() : const Dashboard(),
          transition: Transition.zoom,
          duration: const Duration(milliseconds: 1000),
        );
      }
    });

    _animationController.forward(); // Start the animation



  }
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              Container(
                width: 120,
                height: 120,
                decoration: ShapeDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/ic_launcher.png"),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 100,),
              const Text(
                'Welcome to Attendance App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w300,
                  height: 0,
                  letterSpacing: 4.80,
                ),
              ),

              // Spacer(),
              const SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.only(left: 16,right: 16),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 8,
                  child: LinearProgressIndicator(
                    value: _animationController.value,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff843fc9)),
                    backgroundColor: const Color(0xffd9d9d9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }
}
