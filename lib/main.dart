import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/modules/splash/splash_screen.dart';
import 'package:mafhom/shared/bloc_observer.dart';
import 'package:mafhom/shared/cubit/cubit.dart';
import 'package:mafhom/shared/cubit/states.dart';
import 'package:mafhom/shared/dio_helper.dart';
import 'package:mafhom/shared/sharedpreferences.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await SharedPreferencesHelper.init();
  // bool onboardingSubmit =
  //     sharedPreferencesHelper.getData(key: "onboardingSubmit");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocBuilder<AppCubit,AppStates>(
        builder: (context,state)
        {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mafhom',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff4d689d)),
              useMaterial3: true,
            ),
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
