import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mafhom/layout/home_layout.dart';
import 'package:mafhom/modules/login/login_screen.dart';
import 'package:mafhom/modules/onboarding/onboarding_screen.dart';
import 'package:mafhom/shared/sharedpreferences.dart';

import '../../shared/components.dart';
import '../../shared/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;
  bool? onboardingSubmit =
      SharedPreferencesHelper.getData(key: "onboardingSubmit");
  String? token = SharedPreferencesHelper.getData(key: 'loginToken');

  @override
  void initState() {
    super.initState();

    ///NO Notification Bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    ///Animation Function
    initSlidingAnimation();

    ///Navigate To Next Screen
    navigateToNextScreen();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();

    ///Return Notification Bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: AssetImage('assets/images/logo/logo.png'),
              ),
              Column(
                children: [
                  Text(
                    'Mafhom',
                    style: TextStyle(
                      fontSize: 44,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  SizedBox(height: 40),
                  AnimatedBuilder(
                      animation: slidingAnimation,
                      builder: (context, widget) {
                        return SlideTransition(
                          position: slidingAnimation,
                          child: Text(
                            'Understand Everyone',
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xff8BA9E3),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      if (onboardingSubmit != null) {
        navigateAndFinish(
          context,
          token != '' && token != null ? HomeLayout() : LoginScreen(),
        );
      } else {
        navigateAndFinish(context, OnBoardingScreen());
      }
    });
  }

  void initSlidingAnimation() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 30), end: Offset.zero)
            .animate(animationController);
    animationController.forward();
  }
}
