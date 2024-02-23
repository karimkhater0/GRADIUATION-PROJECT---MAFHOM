import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mafhom/modules/register/register_screen.dart';
import 'package:mafhom/modules/splash/splash_screen.dart';
import 'package:mafhom/shared/bloc_observer.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/dio_helper.dart';

import 'layout/home_layout.dart';
import 'modules/login/forget_password_screen.dart';



void main() {

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mafhom',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff4d689d)),
        useMaterial3: true,
      ),
      home:SplashScreen(),
    );
  }
}
