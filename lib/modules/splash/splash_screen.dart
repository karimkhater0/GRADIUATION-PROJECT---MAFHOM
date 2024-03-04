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
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    bool? onboardingSubmit =
        sharedPreferencesHelper.getData(key: "onboardingSubmit");
    String? loginToken = sharedPreferencesHelper.getData(key: "loginToken");
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2), () {
      if (onboardingSubmit == true && loginToken != null) {
        navigateAndFinish(context, HomeLayout());
      } else if (onboardingSubmit == true) {
        navigateAndFinish(context, LoginScreen());
      } else {
        navigateAndFinish(context, OnBoardingScreen());
      }
      // if (onboardingSubmit == true) {
      //   if (loginToken != "") {
      //     navigateAndFinish(context, HomeLayout());
      //   } else {
      //     navigateAndFinish(context, LoginScreen());
      //   }
      // } else {
      //   navigateAndFinish(context, OnBoardingScreen());
      // }
      // navigateAndFinish(context,
      //     onboardingSubmit == true ? LoginScreen() : OnBoardingScreen());
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        child: const Center(
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
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  'Understand Everyone',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff8BA9E3),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
